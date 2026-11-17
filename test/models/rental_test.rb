require "test_helper"

class RentalTest < ActiveSupport::TestCase
  setup do
    @customer = Customer.create!(name: "Maria Santos")
    @movie = Movie.create!(title: "O Poderoso Chefão")
  end

  test "should create rental with available movie" do
    rental = Rental.new(movie: @movie, customer: @customer)
    assert rental.save, "Could not save rental with available movie"
    assert_not_nil rental.rented_at
    assert_equal "rented", @movie.reload.status
  end

  test "should not create rental with rented movie" do
    @movie.update!(status: "rented")
    rental = Rental.new(movie: @movie, customer: @customer)
    assert_not rental.save, "Saved rental with rented movie"
    assert_includes rental.errors[:base], "Filme já alugado. Devolva antes de alugar de novo."
  end

  test "should return movie" do
    rental = Rental.create!(movie: @movie, customer: @customer)
    assert_equal "rented", @movie.reload.status

    assert rental.return!, "Could not return the movie"
    assert_not_nil rental.returned_at
    assert_equal "available", @movie.reload.status
  end

  test "should not return movie twice" do
    rental = Rental.create!(movie: @movie, customer: @customer)
    rental.return!

    assert_not rental.return!, "Returned the movie twice"
  end

  test "returned? should be false for active rental" do
    rental = Rental.create!(movie: @movie, customer: @customer)
    assert_not rental.returned?
  end

  test "returned? should be true for returned rental" do
    rental = Rental.create!(movie: @movie, customer: @customer)
    rental.return!
    assert rental.returned?
  end

  test "can rent the same movie again after returning it" do
    Rental.create!(movie: @movie, customer: @customer).return!
    assert_equal "available", @movie.reload.status

    assert Rental.create!(movie: @movie, customer: @customer), "Could not rent the movie again after returning"
    assert_equal "rented", @movie.reload.status
  end
end
