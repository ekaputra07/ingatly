class ReminderMailer < ApplicationMailer
    def reminder(user, event, email_to=nil)
        @user = user
        @event = event
        @to = (email_to)? email_to : user.email
        mail to: @to, subject: "[Ingatly] Pengingat: #{ event.title }"
    end

    def send_verification_token(reminder)
        @reminder = reminder
        @token = reminder.set_token
        mail to: reminder.identifier, subject: "[Ingatly] Verifikasi email"
    end
end
