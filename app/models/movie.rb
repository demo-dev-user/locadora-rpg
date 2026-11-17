class Movie < ApplicationRecord
  STATUSES = %w[available rented].freeze

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }

  before_validation :set_default_status, on: :create

  def available?
    status == 'available'
  end

  def rented?
    status == 'rented'
  end

  private

  def set_default_status
    self.status ||= 'available'
  end
end
