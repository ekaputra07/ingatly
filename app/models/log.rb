class Log < ActiveRecord::Base
    CHECK_EVENTS = 0
    SEND_REMINDER = 1

    TYPES = {check_events: CHECK_EVENTS, send_reminder: SEND_REMINDER}

    def self.add(type, message, user=nil, event=nil, reminder=nil)
        params = {log_type: type, message: message}
        if user
            params[:user_id] = user.id
        end
        if event
            params[:event_id] = event.id
        end
        if reminder
            params[:reminder_id] = reminder.id
        end
        Log.create(params)
        message
    end
end
