require "test_helper"

class RentalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer = Customer.create!(name: "Cliente Teste")
    @movie = Movie.create!(title: "Filme Teste", status: "available")
  end

  test "should get index" do
    get rentals_url
    assert_response :success
  end

  test "should get new" do
    get new_rental_url
    assert_response :success
  end

  test "should create rental with available movie" do
    assert_difference("Rental.count") do
      post rentals_url, params: { rental: { movie_id: @movie.id, customer_id: @customer.id } }
    end

    assert_redirected_to rentals_url
    assert_equal "rented", @movie.reload.status
  end

  test "should not create rental with rented movie" do
    @movie.update!(status: "rented")

    assert_no_difference("Rental.count") do
      post rentals_url, params: { rental: { movie_id: @movie.id, customer_id: @customer.id } }
    end

    assert_response :unprocessable_entity
  end

  test "should show clean error message when renting a rented movie" do
    @movie.update!(status: "rented")

    post rentals_url, params: { rental: { movie_id: @movie.id, customer_id: @customer.id } }

    assert_match(/Filme já alugado\. Devolva antes de alugar de novo\./, response.body)
    assert_no_match(/Movie Filme já alugado/, response.body)
  end

  test "should return rental" do
    rental = Rental.create!(movie: @movie, customer: @customer)

    patch return_rental_url(rental)

    assert_redirected_to rentals_url
    assert rental.reload.returned?
    assert_equal "available", @movie.reload.status
  end

  test "should not return rental twice" do
    rental = Rental.create!(movie: @movie, customer: @customer)
    rental.return!

    patch return_rental_url(rental)

    assert_redirected_to rentals_url
    follow_redirect!
    assert_match(/já foi devolvida/, flash[:alert])
  end
end
