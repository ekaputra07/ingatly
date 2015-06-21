class User < ActiveRecord::Base
  has_many :events
  has_many :reminders

  after_create :create_default_reminder_for_user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable,
         :trackable, :validatable, :omniauthable, :recoverable, :confirmable

  def self.find_for_google_oauth2(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    if user
        user.update_attributes(oauth_token: auth.credentials.token,
                               oauth_refresh_token: auth.credentials.refresh_token,
                               oauth_token_expires: Time.at(auth.credentials.expires_at))
        user
    else
        user = User.create(provider: auth.provider,
                           uid: auth.uid,
                           email: auth.info.email,
                           password: Devise.friendly_token[0,20],
                           oauth_token: auth.credentials.token,
                           oauth_refresh_token: auth.credentials.refresh_token,
                           oauth_token_expires: Time.at(auth.credentials.expires_at))
    end
  end

  protected

    def create_default_reminder_for_user
        # Create email reminder for user.
        Reminder.create(user: self, reminder_type: 0, identifier: email, verified: true)
    end
end
