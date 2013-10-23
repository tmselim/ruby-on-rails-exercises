class Order < ActiveRecord::Base
  validates :customer_name, :customer_email, :description, :price, presence: true
  validate :completion_date_must_be_in_past

  scope :unpaid, -> { where("paid_for_on is null") }

  private

  def completion_date_must_be_in_past
    errors.add(:completed_on, "Can't be in the future") if completed_on && completed_on > Time.now
  end

end
