class SendReminderJob < ActiveJob::Base
  queue_as :default

  def perform(reminder, user, event)
    if reminder.reminder_type == 0 #email
        ReminderMailer.reminder(user, event, email_to=reminder.identifier).deliver_later
        log_msg = Log.add(Log::SEND_REMINDER, "[SEND_REMINDER] send EMAIL reminder to #{reminder.identifier}.", user, event, reminder)
        puts log_msg

    elsif reminder.reminder_type == 1 #SMS
        result = Reminder.sms_client.reguler(reminder.identifier, "Pengingat:\n#{event.title}.\n\n-- ingatly.com --")
        log_msg = Log.add(Log::SEND_REMINDER, "[SEND_REMINDER] send SMS reminder to #{reminder.identifier}. result: #{result.inspect}", user, event, reminder)
        puts log_msg
    end
  end
end
