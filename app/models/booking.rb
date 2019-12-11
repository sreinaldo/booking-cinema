class Booking < Sequel::Model
  many_to_one :movie

  plugin :validation_helpers

  dataset_module do
    def by_date_and_movie(date, movie_id)
      where(date: date, movie_id: movie_id)
    end

    def by_date(date)
      where(date: date)
    end
  end

  def validate
    super
    validates_presence [:date, :movie_id, :first_name, :last_name, :email]
    validates_type Date, :date
    validates_type Integer, :movie_id
    validates_type String, [:first_name, :last_name]
    validates_type String, [:first_name, :last_name]
    validates_format URI::MailTo::EMAIL_REGEXP, :email
    errors.add(:movie, 'not exist') if !movie_exists?
    errors.add(:date, 'is sold out, please try another date') if sold_out?
    errors.add(:date, 'should equal or greater than today') if old_date?
  end

  def sold_out?
    Booking.by_date_and_movie(self.date, self.movie_id).count >= MAX_BOOKS
  end


  def movie_exists?
    Movie.find(id: self.movie_id).present?
  end

  def old_date?
    self.date.to_date < Time.now.strftime("%Y-%m-%d").to_date
  end
end
