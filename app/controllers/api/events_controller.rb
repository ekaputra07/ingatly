class Api::EventsController < ApplicationController
  before_action :authenticate_user!
  @@per_page = 10

  def index
    page = params[:page]? params[:page].to_i : 1
    offset = 0
    if page > 1
      offset = (page - 1) * @@per_page
    end

    if current_user.is_admin
      total = Event.count
      @events = Event.order(created_at: :desc).limit(@@per_page).offset(offset)
    else
      total = Event.where(user: current_user).count
      @events = Event.where(user: current_user).order(created_at: :desc).limit(@@per_page).offset(offset)
    end

    has_prev = page > 1
    has_next = (page * @@per_page) < total

    respond_to do |format|
        format.json {render json: {status: :ok, total: total, page: page,
                                   has_prev: has_prev, has_next: has_next, results: @events}}
    end
  end

end
