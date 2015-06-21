class Api::EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:all] and current_user.is_admin
      @events = Event.all.order(created_at: :desc)
    else
      @events = Event.where(user: current_user).order(created_at: :desc)
    end

    respond_to do |format|
        format.json {render json: {status: :ok, results: @events}}
    end
  end

end
