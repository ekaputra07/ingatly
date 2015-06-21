require 'rajasms'
require 'digest/sha1'

class Reminder < ActiveRecord::Base
    belongs_to :user
    has_and_belongs_to_many :events
    validates_presence_of :user, :reminder_type, :identifier
    validate :correct_identifier_format

    TYPES = [{id: 0, name: 'Email', desc: 'Pengingat via email'},
             {id: 1, name: 'SMS', desc: 'Pengingat via SMS'}
            ]

    def self.sms_client
        Rajasms::Client.new(ENV['rajasms_username'], ENV['rajasms_password'], ENV['rajasms_apikey'])
    end

    def set_token
        s = %W[1 2 3 4 5 6 7 8 9 0]
        s.shuffle!
        token = s[0...4].join
        hashed_token = Digest::SHA1.hexdigest(token)
        update_attribute(:verification_token, hashed_token)
        token
    end

    def valid_token?(token)
        hashed_token = Digest::SHA1.hexdigest(token)
        hashed_token == verification_token
    end

    def type_info
        info = nil
        TYPES.each do |t|
            if reminder_type == t[:id]
                info = t
                break
            end
        end
        info
    end

    def type_name
        "#{type_info[:name]}"
    end

    def type_full_name
        "#{type_info[:name]} (#{identifier})"
    end

    def deliver(event)
        if verified
            SendReminderJob.perform_later(self, user, event)
        end
    end

    private
        def correct_identifier_format
            if reminder_type == 0 #email

                # simple check for valid email address
                if !(identifier =~ /@/)
                    errors.add :tujuan, "harus alamat email yang valid"
                end
            end

            if reminder_type == 1 #SMS
                is_number = Float(identifier) != nil rescue false
                if !is_number
                    errors.add :tujuan, "harus nomer handphone. format: 08xxxx"
                end
            end

            # don't allow duplicate email/number
            # exists = Reminder.find_by(identifier: identifier)
            # if exists
            #     errors.add :tujuan, "sudah terdaftar sebelumnya"
            # end
        end
end
