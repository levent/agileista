class Theming < ActiveRecord::Base
  
  belongs_to :theme
  belongs_to :themable, :polymorphic => true

  # def before_destroy
  #   # disallow orphaned tags
  #   theme.destroy_without_callbacks if theme.themings.count < 2  
  # end

  
end
