module V1
  class Bookings < Grape::API
    include V1Base

    resource :bookings do
      desc 'Create booking', http_codes: [
          { code: RESPONSE_CODE[:created], message: 'success' },
          { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' }
      ]
      params do
        requires :first_name, type: String, desc: 'First Name'
        requires :last_name, type: String, desc: 'Last Name'
        requires :email, type: String, desc: 'Email'
        requires :date, type: Date, desc: 'Date'
        requires :movie_id, type: Integer, desc: 'Movie ID'
      end

      post do
        create_booking = CreateBooking.new()
        result = create_booking.call(declared(params))

        if result.success?
          present result.success, with: V1::Entities::Booking
        else
          error = result.failure.errors.full_messages.join(', ')
          render_error(RESPONSE_CODE[:unprocessable_entity], error)
          return
        end
      end

      desc 'List of booking by day', http_codes: [
          { code: RESPONSE_CODE[:success], message: 'success' },
          { code: RESPONSE_CODE[:bad_request], message: 'invalid param' }
      ]

      params do
        requires :date, type: Date, desc: 'Date'
      end

      get do
        bookings = Booking.by_date(declared(params)[:date]).all
        present bookings, with: V1::Entities::Booking, type: 'all'
      end
    end
  end
end
