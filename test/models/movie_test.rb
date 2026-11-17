require "test_helper"

class MovieTest < ActiveSupport::TestCase
  test "should not save movie without title" do
    movie = Movie.new
    assert_not movie.save, "Saved the movie without a title"
  end

  test "should save movie with title" do
    movie = Movie.new(title: "O Senhor dos Anéis")
    assert movie.save, "Could not save the movie with a title"
  end

  test "should have default status available" do
    movie = Movie.create(title: "Star Wars")
    assert_equal "available", movie.status
    assert movie.available?
  end

  test "should not save movie with invalid status" do
    movie = Movie.new(title: "Matrix", status: "invalid")
    assert_not movie.save, "Saved the movie with an invalid status"
  end

  test "rented? should return true when status is rented" do
    movie = Movie.create(title: "Matrix", status: "rented")
    assert movie.rented?
    assert_not movie.available?
  end
end
