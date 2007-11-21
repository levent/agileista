class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  
  

  def before_destroy
    # disallow orphaned tags
    tag.destroy_without_callbacks if tag.taggings.count < 2  
  end
  
end
