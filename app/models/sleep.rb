# == Schema Information
#
# Table name: sleeps
#
#  id         :integer          not null, primary key
#  start      :datetime
#  end        :datetime
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Sleep < ActiveRecord::Base
  attr_accessible :start, :end

  validates_presence_of :start, :end
  validate :ends_after_start

  belongs_to :user

  private

  def ends_after_start
    if self.end.present? && start.present? && self.end < start
      errors.add(:end, "can't happen before start time")
    end
  end
end
