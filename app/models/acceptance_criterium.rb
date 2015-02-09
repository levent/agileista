# Criterium is not the singular for Criteria
class AcceptanceCriterium < ActiveRecord::Base
  include RankedModel
  belongs_to :user_story, touch: true

  validates :detail, presence: true
  validates :detail, length: { maximum: 255 }

  ranks :story_order,
        column: :position,
        with_same: :user_story_id
end
