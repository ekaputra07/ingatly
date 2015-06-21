require 'test_helper'

class EventTest < ActiveSupport::TestCase
    test "to_utc_weekday should perform correctly" do
        event = Event.new

        Time.zone = "Hong Kong"
        # in HongKong (GMT+8) time, when it at 7:00 in Monday, in UTC time it still at 23:00 in Sunday
        # it mean if we expecting at 7:00 on Monday (wday = 1), the UTC wday must in Sunday (wday = 0)
        utc_wday = event.to_utc_weekday(1, 7)
        assert_equal(0, utc_wday)

        # in HongKong (GMT+8) time, when it at 12:00 in Monday, in UTC time it still at 04:00 in Monday
        # it mean if we expecting at 12:00 on Monday (wday = 1), the UTC wday must in Monday (wday = 1)
        utc_wday = event.to_utc_weekday(1, 12)
        assert_equal(1, utc_wday)

        Time.zone = "Alaska"
        # in Alsaka (GMT-8) time, when it at 23:00 in Monday, in UTC time its already at 07:00 in Tuesday
        # it mean if we expecting at 23:00 on Monday (wday = 1), the UTC wday must in Tuesday (wday = 2)
        utc_wday = event.to_utc_weekday(1, 23)
        assert_equal(2, utc_wday)

        # in Alsaka (GMT-8) time, when it at 01:00 in Monday, in UTC time its already at 09:00 in Monday
        # it mean if we expecting at 01:00 on Monday (wday = 1), the UTC wday also in Monday (wday = 1)
        utc_wday = event.to_utc_weekday(1, 1)
        assert_equal(1, utc_wday)
    end

    test "to_local_weekday should perform correctly" do
        event = Event.new

        Time.zone = "Hong Kong"
        # in HongKong (GMT+8) time, when in UTC at 23:00 in Sunday (0), in localtime it should be 07:00 in Monday (1)
        utc_wday = event.to_local_weekday(0, 23)
        assert_equal(1, utc_wday)

        # in HongKong (GMT+8) time, when in UTC at 06:00 in Sunday (0), localtime it should be 14:00 in Sunday (0)
        utc_wday = event.to_local_weekday(0, 6)
        assert_equal(0, utc_wday)

        Time.zone = "Alaska"
        # in Alsaka (GMT-8) time, when in UTC at 23:00 in Sunday (0), in localtime it should be 15:00 in Sunday (0)
        utc_wday = event.to_local_weekday(0, 23)
        assert_equal(0, utc_wday)

        # in Alsaka (GMT-8) time, when in UTC at 03:00 in Sunday (0), in localtime it should be 19:00 in Saturday (6)
        utc_wday = event.to_local_weekday(0, 3)
        assert_equal(6, utc_wday)

    end
end
