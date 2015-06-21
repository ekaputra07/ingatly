class Users::PasswordsController < Devise::PasswordsController

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)

      # nopasswd indicates user registered using their social media account, that means
      # they has a random generated password set.
      # When they are able to set their password via password reset, we set this state to false.
      resource.update_attribute(:nopasswd, false)

      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_flashing_format?
      sign_in(resource_name, resource)
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      respond_with resource
    end
  end

end
