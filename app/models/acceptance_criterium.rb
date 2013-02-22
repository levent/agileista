class AcceptanceCriterium < ActiveRecord::Base  
  belongs_to :user_story, :touch => true

  validates_presence_of :detail
end
