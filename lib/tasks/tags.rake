namespace :tags do
  namespace :mung do
    desc "migrate from has many polymorphs"
    task(:migrate => :environment) do
      Tagging.all.each do |tagging|
        tagging.context = "tags"
        account_id = tagging.tag.account_id if tagging.tag
        if account_id
          tagging.tagger_type = "Account"
          tagging.tagger_id = account_id
        end
        tagging.save!
      end
    end
  end
end