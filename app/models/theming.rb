class Theming < ActiveRecord::Base
  belongs_to :theme
  belongs_to :themable, :polymorphic => true
  
  belongs_to :user_story, :foreign_key => :themable_id
  
end