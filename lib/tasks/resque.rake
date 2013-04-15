require 'resque/tasks'

# load the Rails app all the time
namespace :resque do
  puts "Loading Rails environment for Resque"
  task :setup => :environment do
    require 'sprint'
    require 'burndown'
    ActiveRecord::Base.descendants.each { |klass|  klass.columns }
  end
end
