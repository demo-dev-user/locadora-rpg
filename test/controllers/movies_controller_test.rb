require "test_helper"

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie = Movie.create!(title: "Filme Teste", status: "available")
  end

  test "should get index" do
    get movies_url
    assert_response :success
  end

  test "should get new" do
    get new_movie_url
    assert_response :success
  end

  test "should create movie" do
    assert_difference("Movie.count") do
      post movies_url, params: { movie: { status: "available", title: "Novo Filme" } }
    end

    assert_redirected_to movie_url(Movie.last)
  end

  test "should create movie with default available status when status is blank" do
    assert_difference("Movie.count") do
      post movies_url, params: { movie: { title: "Filme Sem Status" } }
    end

    assert_equal "available", Movie.last.status
  end

  test "should show movie" do
    get movie_url(@movie)
    assert_response :success
  end

  test "should get edit" do
    get edit_movie_url(@movie)
    assert_response :success
  end

  test "should update movie" do
    patch movie_url(@movie), params: { movie: { status: "available", title: "Filme Atualizado" } }
    assert_redirected_to movie_url(@movie)
  end

  test "should destroy movie" do
    assert_difference("Movie.count", -1) do
      delete movie_url(@movie)
    end

    assert_redirected_to movies_url
  end
end
