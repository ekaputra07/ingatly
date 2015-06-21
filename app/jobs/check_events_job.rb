class CheckEventsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Event.check_events
  end
end
