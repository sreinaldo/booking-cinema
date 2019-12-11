require "rails_helper"

describe "Movie APIs"  do
  let!(:movies) do
    create_list(:movie, 5)
  end

  describe "GET # movies" do
    it "Return list of movies by day of week" do
      day_of_week = 0
      params = {"day_of_week": day_of_week}
      get "/api/movies", params: params, headers: request_headers
      json_data = json_response

      movies.each do |movie|
        expect(json_data.detect {|row| row[:description] == movie.description}).not_to be_nil
        expect(json_data.detect {|row| row[:name] == movie.name}).not_to be_nil
        expect(json_data.detect {|row| row[:image_url] == movie.image_url}).not_to be_nil
        expect(json_data.detect {|row| row[:show_days].include? day_of_week}).not_to be_nil
      end
    end

    it "Return empty response" do
      day_of_week = 5
      params = {"day_of_week": day_of_week}
      get "/api/movies", params: params, headers: request_headers
      json_data = json_response
      expect(json_data).to be_empty
    end
  end

  describe "POST #movies" do
    let!(:movie) do
      create(:movie)
    end

    let!(:movie_attributes) do
      FactoryGirl.attributes_for :movie
    end

    context "when is successfully created" do
      it "render created movie" do
        post "/api/movies", params: movie_attributes.to_json, headers: request_headers
        json_data = json_response
        expect(json_data[:name]).to eql movie_attributes[:name]
      end
    end

    context "when has error" do
      it "render unprocessable_entity error when name is missing" do
        movie_attributes[:name] = ""
        post "/api/movies", params: movie_attributes.to_json, headers: request_headers

        json_data = json_response
        expect(json_data.blank?).to eql false

        expect(json_response[:meta][:code]).to eql RESPONSE_CODE[:unprocessable_entity]
        expect(json_response[:meta][:message].downcase).to include "name is not present"
      end

      it "render unprocessable_entity error when name is duplicate" do
        movie_attributes[:name] = movie.name
        post "/api/movies", params: movie_attributes.to_json, headers: request_headers

        json_data = json_response
        expect(json_data.blank?).to eql false

        expect(json_response[:meta][:code]).to eql RESPONSE_CODE[:unprocessable_entity]
        expect(json_response[:meta][:message].downcase).to include "name is already taken"
      end

      it "render unprocessable_entity error when show_days is invalid" do
        movie_attributes[:show_days] = 10
        post "/api/movies", params: movie_attributes.to_json, headers: request_headers

        json_data = json_response
        expect(json_data.blank?).to eql false

        expect(json_response[:meta][:code]).to eql RESPONSE_CODE[:unprocessable_entity]
        expect(json_response[:meta][:message].downcase).to include "show_days invalid day of week"
      end

    end
  end

end
