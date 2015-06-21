class Event < ActiveRecord::Base
    belongs_to :user
    has_and_belongs_to_many :reminders
    accepts_nested_attributes_for :reminders

    validates :user, presence: true
    validates :title, presence: true, length: {maximum: 255}
    validates :event_type, presence: true
    validate :event_time_must_future
    before_validation :make_reminder_datetime

    scope :active, -> { where active: true }

    TYPES = [['Sekali saja', 'ONCE'],
            ['Setiap hari', 'DAILY'],
            ['Setiap minggu', 'WEEKLY'],
            ['Setiap bulan', 'MONTHLY'],
            ['Setiap tahun', 'YEARLY']]

    DAYS = [['Minggu', 0],
            ['Senin', 1],
            ['Selasa', 2],
            ['Rabu', 3],
            ['Kamis', 4],
            ['Jumat', 5],
            ['Sabtu', 6]]

    MONTHS = [['Januari', 1],
            ['Februari', 2],
            ['Maret', 3],
            ['April', 4],
            ['Mei', 5],
            ['Juni', 6],
            ['Juli', 7],
            ['Agustus', 8],
            ['September', 9],
            ['Oktober', 10],
            ['November', 11],
            ['Desember', 13]]

    #virtual attributes Getter
    def r_year
        (reminder_time.nil?)? @r_year : reminder_time.year
    end

    def r_month
        (reminder_time.nil?)? @r_month : reminder_time.month
    end

    def r_day
        (reminder_time.nil?)? @r_day : reminder_time.day
    end

    def r_hour
        (reminder_time.nil?)? @r_hour : reminder_time.hour
    end

    def r_wday
        (wday.nil?)? @r_wday : to_local_weekday(wday, reminder_time.utc.hour)
    end

    #virtual attributes Setter
    def r_year=(val)
        @r_year = val
    end

    def r_month=(val)
        @r_month = val
    end

    def r_day=(val)
        @r_day = val
    end

    def r_hour=(val)
        @r_hour = val
    end

    def r_wday=(val)
        @r_wday = val
    end

    def self.month_name(number)
        month_name = 'Invalid month!'
        MONTHS.each do |name, num|
            if number == num
                month_name = name
            end
        end
        month_name
    end

    def self.day_name(number)
        day_name = 'Invalid day!'
        DAYS.each do |name, num|
            if number == num
                day_name = name
            end
        end
        day_name
    end

    def as_story
        if event_type == 'ONCE'
            "Pada #{r_day} #{Event::month_name r_month} #{r_year}, pukul #{r_hour}:00"
        elsif event_type == 'DAILY'
            "Setiap hari pukul #{r_hour}:00"
        elsif event_type == 'WEEKLY'
            "Setiap hari #{Event.day_name r_wday}, pukul #{r_hour}:00"
        elsif event_type == 'MONTHLY'
            "Setiap tanggal #{r_day}, pukul #{r_hour}:00"
        else
            "Setiap tanggal #{r_day} #{Event::month_name r_month}, pukul #{r_hour}:00"
        end
    end

    def send_reminder
        self.reminders.each do |r|
            r.deliver(self)
        end
    end

    def self.check_events
        check_time = Time.now.utc
        events = Event.active.where("DATE_PART('hour', reminder_time) = ?", check_time.hour)

        log_msg = Log.add(Log::CHECK_EVENTS, "[CHECK_EVENTS] Total #{events.count} event(s) found at #{check_time} check time.")
        puts log_msg

        events.each do |event|
            weekday_match = event.wday == check_time.wday
            day_match = event.r_day == check_time.day
            month_match = event.r_month == check_time.month
            year_match = event.r_year == check_time.year

            # in case daily event, hour should match.
            if event.event_type == 'DAILY'
                puts "#{event.title} match daily"
                event.send_reminder

            # in case weekly
            elsif (event.event_type == 'WEEKLY') && weekday_match
                puts "#{event.title} match weekly"
                event.send_reminder

            # in case monthly
            elsif (event.event_type == 'MONTHLY') && day_match
                puts "#{event.title} match monthly"
                event.send_reminder

            # in case yearly
            elsif (event.event_type == 'YEARLY') && day_match && month_match
                puts "#{event.title} match yearly"
                event.send_reminder

            # in case once
            elsif (event.event_type == 'ONCE') && day_match && month_match && year_match
                puts "#{event.title} match one time event."
                event.send_reminder
                event.update_attribute(:active, false)
            end

        end
    end


    def to_utc_weekday(local_wday, local_hour)
        # guessing wday in utc time if local wday and local hour are given.
        # this part little bit tricky, maybe will raise a bug in the future.

        now = Time.zone.now

        # find week day delta from local and utc based on provided local hour
        local_time = Time.zone.local(now.year, now.month, now.day, local_hour)
        utc_time = local_time.utc

        wday_delta = local_time.wday - utc_time.wday

        utc_wday = local_wday.to_i - wday_delta
        if utc_wday > 6
            # if utc_wday = 7, its means back to sunday or `0`
            return 0
        elsif utc_wday < 0
            return 6
        else
            return utc_wday
        end
    end

    def to_local_weekday(utc_wday, utc_hour)
        # guessing wday in local time if utc wday and utc hour are given.
        # this part little bit tricky, maybe will raise a bug in the future.

        now = Time.now.utc

        # find week day delta from local and utc based on provided local hour
        utc_time = Time.utc(now.year, now.month, now.day, utc_hour)
        local_time = utc_time.in_time_zone

        wday_delta = local_time.wday - utc_time.wday

        local_wday = utc_wday + wday_delta
        if local_wday > 6
            # if local_wday = 7, its means back to sunday or `0`
            return 0
        elsif local_wday < 0
            return 6
        else
            return local_wday
        end
    end

    protected
        def make_reminder_datetime
            localtime = Time.zone.local(@r_year, @r_month, @r_day, @r_hour)
            self.wday = to_utc_weekday(@r_wday, @r_hour)
            self.reminder_time = localtime.utc
        end

        def event_time_must_future
            if event_type == 'ONCE'
                if reminder_time < Time.zone.now
                    errors.add :waktu, I18n.t('custom.inthepast')
                end
            end
        end
end
