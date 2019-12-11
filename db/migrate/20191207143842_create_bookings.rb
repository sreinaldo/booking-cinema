Sequel.migration do
  change do

    create_table :bookings do
      primary_key :id
      Date :date, null: false, require: true
      String :first_name, null: false, require: true
      String :last_name, null: false, require: true
      String :email, null: false, require: true
      foreign_key(:movie_id, :movies)
    end

  end
end
