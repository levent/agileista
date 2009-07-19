# Given /^the following sprint stories:$/ do |stories|
#   stories.hashes.each do |story|
#     account = Account.find_by_name(story[:account])
#     sprint = Sprint.find_by_name(story[:sprint])
#     UserStory.make(:sprint => sprint, :definition => story[:definition])
#   end
# end
