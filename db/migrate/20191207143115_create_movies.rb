Sequel.migration do
  change do

    create_table :movies do
      primary_key :id
      String :name, null: false, require: true
      String :description, null: false, require: true
      String :image_url, null: false, require: true
      String :show_days, type: "integer[]", null: false, require: true
    end

  end
end
