class Recipient < ActiveRecord::Base
  belongs_to :user
  has_many :alerts
end
