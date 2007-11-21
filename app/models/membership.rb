class Membership < ActiveRecord::Base

  belongs_to :person
  belongs_to :account

end
