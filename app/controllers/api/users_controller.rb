class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  @@per_page = 10

  def index
    page = params[:page]? params[:page].to_i : 1
    offset = 0
    if page > 1
      offset = (page - 1) * @@per_page
    end

    total = User.count
    @users = User.order(created_at: :desc).limit(@@per_page).offset(offset)

    has_prev = page > 1
    has_next = (page * @@per_page) < total

    respond_to do |format|
        format.json {render json: {status: :ok, total: total, page: page,
                                   has_prev: has_prev, has_next: has_next, results: @users}}
    end
  end

  def admin_only
    if !current_user.is_admin
        render plain: 'Not found'
    end
  end

end
