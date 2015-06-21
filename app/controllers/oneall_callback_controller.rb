class OneallCallbackController < ApplicationController
  protect_from_forgery with: :exception, except: [:index]

  def index
      connection_token = params[:connection_token]
      if connection_token
        sign_in_or_register(connection_token)
      end
  end

  private
    def sign_in_or_register(connection_token)
        oneall_subdomain = ENV['oneall_subdomain']
        oneall_public_key = ENV['oneall_public_key']
        oneall_private_key = ENV['oneall_private_key']

        oneall_connection_url = "https://#{oneall_subdomain}.api.oneall.com/connections/#{connection_token}.json"
        resp = HTTParty.get(oneall_connection_url, basic_auth: {username: oneall_public_key, password: oneall_private_key})
        data = resp.parsed_response['response']['result']['data']

        key = data['plugin']['key']
        status = data['plugin']['data']['status']

        # social login
        if key && (key == 'social_login' || key == 'single_sign_on') && status == 'success'
            provider = data['user']['identity']['source']['name']
            user_token = data['user']['user_token']
            email = data['user']['identity']['emails'][0]['value'] rescue nil

            user = User.find_by(oneall_token: user_token)
            # token match
            if user
                sign_in(user)
                redirect_to events_path, notice: "Anda login dengan akun #{provider}."
            else
                if email
                    # email match, set oneall_token and login
                    user = User.find_by(email: email)
                    if user
                        # user.update_attribute(:oneall_token, user_token)
                        # sign_in(user)
                        redirect_to new_session_path(:user), alert: "Akun anda belum tersambung dengan #{provider}. Silahkan login dengan email dan sambungkan akun anda dengan media sosial melalui halaman profil."
                    else
                        # nothing match, register new user, generate random pass, skip confirmation and login
                        random_pass = rand(36**8).to_s(36)
                        user = User.new(email: email, password: random_pass,
                                        password_confirmation: random_pass,
                                        oneall_token: user_token, nopasswd: true)
                        user.skip_confirmation!
                        user.save
                        sign_in(user)
                        redirect_to events_path, notice: "Anda mendaftar dengan akun #{provider}."
                    end
                end
            end
        end

        # Social link
        if key && key == 'social_link' && status == 'success'
            link_action = data['plugin']['data']['action']

            # link account
            if link_action == 'link_identity'
                user_token = data['user']['user_token']
                provider = data['user']['identity']['source']['name']
                current_user.update_attribute(:oneall_token, user_token)
                redirect_to edit_user_registration_path, notice: "Akun anda sudah tersambung dengan akun #{provider}."
            end

            # unlink account
            if link_action == 'unlink_identity'
                current_user.update_attribute(:oneall_token, nil)
                redirect_to edit_user_registration_path
            end
        end
    end
end
