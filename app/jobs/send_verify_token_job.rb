class SendVerifyTokenJob < ActiveJob::Base
  queue_as :default

  def perform(reminder)
    token = reminder.set_token
    result = Reminder.sms_client.reguler(reminder.identifier, "Kode verifikasi nomer anda:\n#{token}\n\n-- ingatly.com --")
    puts "[SEND_SMS_VERIFY] send SMS verification token to #{reminder.identifier}. result: #{result.inspect}"
  end
end
