require 'rails_helper'

RSpec.describe "Socials", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/social/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /test" do
    it "returns http success" do
      get "/social/test"
      expect(response).to have_http_status(:success)
    end
  end

end
