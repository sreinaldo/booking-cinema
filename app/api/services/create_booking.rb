require "dry/transaction"

class CreateBooking
  include Dry::Transaction

  step :validate
  step :create

  private

  def validate(params)
    booking = Booking.new(params)
    puts(booking.valid?)
    if booking.valid?
      Success(booking)
    else
      Failure(booking)
    end

  end

  def create(booking)
    booking.save
    Success(booking)
  end
end
