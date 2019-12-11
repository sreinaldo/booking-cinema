require "rails_helper"

describe "Booking APIs"  do
  let!(:movie) do
    create(:movie)
  end

  before(:each) {
    @booking_attributes = FactoryGirl.attributes_for :booking
    @booking_attributes[:movie_id] = movie.id
  }

  describe "POST #bookings" do
    context "when is successfully created" do
      it "render created booking" do
        post "/api/bookings", params: @booking_attributes.to_json, headers: request_headers
        json_data = json_response
        expect(json_data[:email]).to eql @booking_attributes[:email]
      end
    end

    context "when has error" do
      it "render unprocessable_entity error when email is missing" do
        @booking_attributes[:email] = ""
        post "/api/bookings", params: @booking_attributes.to_json, headers: request_headers

        json_data = json_response
        expect(json_data.blank?).to eql false
        expect(json_data[:meta][:code]).to eql RESPONSE_CODE[:unprocessable_entity]
        expect(json_data[:meta][:message].downcase).to include "email is not present"
      end

      it "render unprocessable_entity error when date is sold out" do
        bookings = create_list(:booking, 11, movie_id: movie.id )
        @booking_attributes[:movie_id] = bookings.first.movie_id
        post "/api/bookings", params: @booking_attributes.to_json, headers: request_headers

        json_data = json_response
        expect(json_data.blank?).to eql false
        expect(json_data[:meta][:code]).to eql RESPONSE_CODE[:unprocessable_entity]
        expect(json_data[:meta][:message].downcase).to include ""date is sold out, please try another date""
      end
    end
  end

  describe "GET #booking" do
    it "return list of booking filter by day" do
      bookings = create_list(:booking, 10)
      params = {"date": Time.now.strftime("%Y-%m-%d")}
      get "/api/bookings", params: params, headers: request_headers
      json_data = json_response

      bookings.each do |booking|
        expect(json_data.detect {|row| row[:first_name] == booking.first_name}).not_to be_nil
        expect(json_data.detect {|row| row[:last_name] == booking.last_name}).not_to be_nil
        expect(json_data.detect {|row| row[:email] == booking.email}).not_to be_nil
        expect(json_data.detect {|row| row[:date] == booking.date.strftime("%Y-%m-%d")}).not_to be_nil
        expect(json_data.detect {|row| row[:movie][:id] == booking.movie.id}).not_to be_nil
      end
    end
  end
end
