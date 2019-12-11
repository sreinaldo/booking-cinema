class Movie < Sequel::Model
  one_to_many :books

  plugin :validation_helpers


  dataset_module do
    def by_day_of_week(day)
      where(Sequel.pg_array(:show_days).contains([day]))
    end
  end

  def before_create
    self.show_days = Sequel.pg_array(self.show_days)
    super
  end

  def validate
    super
    validates_presence [:name, :description, :image_url, :show_days]
    validates_unique :name
    validates_format /\Ahttps?:\/\//, :image_url, message: 'is not a valid URL'
    errors.add(:show_days, 'invalid day of week') if !valid_day_of_week?
  end

  def valid_day_of_week?
    return false if self.show_days.nil?
    valid_days = self.show_days.select { |day| DAYS_OF_WEEK.include? day }
    valid_days.length == self.show_days.length
  end
end
