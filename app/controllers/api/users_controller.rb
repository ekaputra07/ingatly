class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  def index
    @users = User.all.order(created_at: :desc)
    respond_to do |format|
        format.json {render json: {status: :ok, total: @users.count, results: @users}}
    end
  end

  def admin_only
    if !current_user.is_admin
        render plain: 'Not found'
    end
  end

end
