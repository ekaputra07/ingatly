class Api::LogsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  def index
    @logs = Log.all.order(created_at: :desc)
    respond_to do |format|
        format.json {render json: {status: :ok, total: @logs.count, results: @logs}}
    end
  end

  def admin_only
    if !current_user.is_admin
        render plain: 'Not found'
    end
  end

end
