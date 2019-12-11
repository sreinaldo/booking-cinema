require "dry/transaction"

class CreateMovie
  include Dry::Transaction

  step :validate
  step :create

  private

  def validate(params)
    movie = Movie.new(params)

    if movie.valid?
      Success(movie)
    else
      Failure(movie)
    end

  end

  def create(movie)
    movie.save
    Success(movie)
  end
end
