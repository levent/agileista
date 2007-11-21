class AddAccountIdToTags < ActiveRecord::Migration
  def self.up
    remove_index :tags, :name
    add_column :tags, :account_id, :integer
    add_index :tags, [:name, :account_id], :unique => true
    for tagging in Tagging.find(:all)
      tag = tagging.tag
      account_id = UserStory.find(tagging.taggable_id).account_id
      puts tag.name.to_s + " :TAG"
      puts account_id
      puts
      tag.account_id = account_id
      tag.save
    end
  end

  def self.down
    remove_index :tags, [:name, :account_id]
    remove_column :tags, :account_id
    add_index :tags, :name, :unique => true
  end
end
