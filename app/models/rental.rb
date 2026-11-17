class Rental < ApplicationRecord
  belongs_to :movie
  belongs_to :customer

  validate :movie_must_be_available, on: :create

  before_create :set_rented_at_and_update_movie

  def returned?
    returned_at.present?
  end

  def return!
    return false if returned?

    transaction do
      update!(returned_at: Time.current)
      movie.update!(status: 'available')
    end
  end

  private

  def movie_must_be_available
    return unless movie

    unless movie.available?
      errors.add(:base, 'Filme já alugado. Devolva antes de alugar de novo.')
    end
  end

  def set_rented_at_and_update_movie
    self.rented_at ||= Time.current
    movie.update!(status: 'rented')
  end
end
