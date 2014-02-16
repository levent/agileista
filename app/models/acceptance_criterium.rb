class AcceptanceCriterium < ActiveRecord::Base
  include RankedModel
  belongs_to :user_story, touch: true

  validates_presence_of :detail
  validates_length_of :detail, maximum: 255

  attr_accessible :detail

  ranks :story_order,
    :column => :position,
    :with_same => :user_story_id
end
