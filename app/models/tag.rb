# require 'user_story'
class Tag < ActiveRecord::Base

  belongs_to :account
  
  has_many_polymorphs :taggables, 
      :from => [:user_stories], 
      :through => :taggings,
      :dependent => :destroy

      
  def self.cloud(args = {})
    find(:all, :select => 'tags.*, count(*) as popularity',
      :limit => args[:limit] || nil,
      :joins => "JOIN taggings ON taggings.tag_id = tags.id",
      :conditions => args[:conditions],
      :group => "taggings.tag_id",
      :order => "popularity DESC" )
  end
end
