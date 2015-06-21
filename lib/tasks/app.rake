namespace :app do
  desc "various tasks for managing events"

  task check_events: :environment do
    Event.check_events
  end

end
