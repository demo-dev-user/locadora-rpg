class RentalsController < ApplicationController
  before_action :set_rental, only: %i[show return]

  def index
    @rentals = Rental.includes(:movie, :customer).order(created_at: :desc)
  end

  def show
  end

  def new
    @rental = Rental.new
    @customers = Customer.all
    @movies = Movie.where(status: 'available')
  end

  def create
    @rental = Rental.new(rental_params)

    if @rental.save
      redirect_to rentals_path, notice: 'Locação registrada com sucesso.'
    else
      @customers = Customer.all
      @movies = Movie.where(status: 'available')
      render :new, status: :unprocessable_entity
    end
  end

  def return
    if @rental.return!
      redirect_to rentals_path, notice: 'Filme devolvido com sucesso.'
    else
      redirect_to rentals_path, alert: 'Esta locação já foi devolvida.'
    end
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def rental_params
    params.require(:rental).permit(:movie_id, :customer_id)
  end
end
