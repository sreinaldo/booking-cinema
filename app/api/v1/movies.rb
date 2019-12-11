module V1
  class Movies < Grape::API
    include V1Base

    resource :movies do
      desc 'Return list of movies by day of week', http_codes: [
          { code: RESPONSE_CODE[:success], message: 'success' },
          { code: RESPONSE_CODE[:bad_request], message: 'invalid param' }
      ]

      params do
        requires :day_of_week, type: Integer, desc: 'Day of week', values: DAYS_OF_WEEK
      end

      get do
        movies = Movie.by_day_of_week(declared(params)[:day_of_week]).all
        present movies, with: V1::Entities::Movie, type: 'all'
      end

      params do
        requires :name, type: String, desc: 'Name'
        requires :description, type: String, desc: 'Description'
        requires :image_url, type: String, desc: 'Image URL'
        requires :show_days, type: Array[String],
                 desc: 'Days of week that will be displayed the movie, e.g: Monday= 0, Tuesday =1, Wednesday=2, Thursday=3, Friday=4, Saturday=5, Sunday=6'

      end

      desc 'Create movie', http_codes: [
          { code: RESPONSE_CODE[:created], message: 'success' },
          { code: RESPONSE_CODE[:unprocessable_entity], message: 'Validation error messages' }
      ]

      post do
        create_movie = CreateMovie.new()
        result = create_movie.call(declared(params))

        if result.success?
          present result.success, with: V1::Entities::Movie
        else
          error = result.failure.errors.full_messages.join(', ')
          render_error(RESPONSE_CODE[:unprocessable_entity], error)
          return
        end
      end
    end
  end
end
