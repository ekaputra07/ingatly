class EventsController < ApplicationController
    before_action :authenticate_user!, except: [:check]
    before_action :set_event_instance, only: [:show, :edit, :update, :destroy]
    before_action :set_reminders_instance, only: [:new, :create, :edit, :update]
    before_filter :set_user_time_zone

    def index
        # If user has no calender yet, create one for them
        if !current_user.time_zone?
            redirect_to setup_path
        end

        @events = Event.where(user: current_user).order(created_at: :desc)
    end

    def new
        # events_count = Event.where(user: current_user).count
        # if events_count < 2
        #     @event = Event.new
        # else
        #     redirect_to events_path, alert: "Jumlah event dibatasi maksimal 2 buah untuk Ingatly Free."
        # end
        @event = Event.new
    end

    def create
        @event = Event.new(event_params)
        @event.user = current_user

        if @event.save
            redirect_to events_path, notice: "Event \"#{@event.title}\" di buat."
        else
            render :new
        end

    end

    def show
    end

    def edit
    end

    def update
        if @event.update(event_params)
            redirect_to events_path, notice: "Event \"#{@event.title}\" di diperbarui."
        else
            render :edit
        end
    end

    def destroy
        @event.destroy
        redirect_to events_path, notice: "Event \"#{@event.title}\" telah dihapus."
    end

    def setup
        if request.patch?
            # save the new timezone
            current_user.update_attribute(:time_zone, params[:user][:time_zone])
            Time.zone = current_user.time_zone
            redirect_to events_path

        elsif request.get?
            # if accessed when time_zone already set, redirect to events
            if current_user.time_zone?
                redirect_to events_path
            end

            @user = current_user
        end
    end

    def check
        CheckEventsJob.perform_later
        render plain: 'ok'
    end

    private
        def set_event_instance
            @event = Event.find_by(id: params[:id], user: current_user)
        end

        def set_reminders_instance
            @reminders = Reminder.where(user: current_user, verified: true)
        end

        def event_params
            params.require(:event).permit(:title, :description, :active, :where, :event_type,
                                          :r_year, :r_month, :r_wday, :r_day, :r_hour,
                                          reminder_ids: [])
        end

        def set_user_time_zone
            Time.zone = current_user.time_zone if user_signed_in? && current_user.time_zone?
        end
end
