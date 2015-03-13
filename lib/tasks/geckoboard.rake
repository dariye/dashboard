require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :geckoboard do
  desc "Update Widgets on Geckoboard"
  task update: :environment do
    time = Benchmark.measure do 
      puts "Updating Active Opportunities Widget..."
      active_opportunities_widget
      puts "Done!"

      puts "Updating Expected Value Widget..."
      expected_value_widget
      puts "Done!"

      puts "Updating Opportunities Funnel Graph..."
      opportunities_funnel_widget
      puts "Done"

      puts "Updating Opportunities Line Graph..."
      opportunities_line_widget
      puts "Done!"

      puts "==> Done Updating Widget <=="
    end
    puts "Time elapsed: #{time}"
  end

end
