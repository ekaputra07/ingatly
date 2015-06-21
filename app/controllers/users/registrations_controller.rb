class Users::RegistrationsController < Devise::RegistrationsController

  protected

    def after_update_path_for(resource)
      # we overrides where redirection goes to after user update their profile
      # in our case go back to profile editor page path
      edit_user_registration_path
    end
end
