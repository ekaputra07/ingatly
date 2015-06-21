class Api::RemindersController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:all] and current_user.is_admin
      @reminders = Reminder.all.order(created_at: :desc)
    else
      @reminders = Reminder.where(user: current_user).order(created_at: :desc)
    end

    respond_to do |format|
        format.json {render json: {status: :ok, results: @reminders}}
    end
  end

end
