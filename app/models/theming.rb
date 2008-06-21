class Theming < ActiveRecord::Base
  belongs_to :theme
  belongs_to :themable, :polymorphic => true
end