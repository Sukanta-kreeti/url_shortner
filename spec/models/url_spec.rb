require "rails_helper"

RSpec.describe Url, type: :model do

  it "is valid with a valid url" do
    url = build(:url)
    expect(url).to be_valid
  end

  it "is invalid without a url" do
    url = build(:url, original_url: nil)
    url.valid?
    expect(url.errors[:original_url]).to include("Please enter the URL you want to shorten")
  end

  it "is invalid with an invalid URL" do
    url = build(:url, original_url: "abc")
    url.valid?
    expect(url.errors[:original_url]).to include("Please enter a valid URL")
  end

  describe "method" do
    before :each do
      @url_google = create(:url, original_url: "google.com")
      @url_google.sanitize
      @url_google.save
    end

    it "#generate_short_url generates a 6-char string containing only letters and numbers" do
      url = build(:url)
      url.generate_short_url
      expect(url.short_url).to match(/\A[a-z\d]{6}\z/i)
    end

    it "#generate_short_url always generates a short_url that is not in the database" do
    end

    it "#find_duplicate finds a duplicate in the database" do
      url = build(:url, original_url: "www.google.com")
      url.sanitize
      expect(url.find_duplicate).to eq(@url_google)
    end

    context "#new_url?" do
      it "returns false if the URL is already present in the database" do
        url = build(:url, original_url: "www.google.com")
        url.sanitize
        expect(url.new_url?).to eq(false)
      end

      it "returns true if the URL is not found in the database" do
        url = build(:url, original_url: "www.toto.com")
        url.sanitize
        expect(url.new_url?).to eq(true)
      end
    end

    context "#sanitize" do

      it "changes 'www.google.com' to 'http://google.com'" do
        url = build(:url, original_url: 'www.google.com')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

      it "changes 'www.google.com/' to 'http://google.com'" do
        url = build(:url, original_url: 'www.google.com/')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

      it "changes 'google.com' to 'http://google.com'" do
        url = build(:url, original_url: 'google.com')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

      it "changes 'https://www.google.com' to 'http://google.com'" do
        url = build(:url, original_url: 'https://www.google.com')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

      it "changes 'http://www.google.com' to 'http://google.com'" do
        url = build(:url, original_url: 'http://www.google.com')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

      it "changes 'www.github.com/DatabaseCleaner/database_cleaner/' to 'http://github.com/DatabaseCleaner/database_cleaner'" do
        url = build(:url, original_url: 'www.github.com/DatabaseCleaner/database_cleaner/')
        url.sanitize
        expect(url.sanitized_url).to eq('http://github.com/databasecleaner/database_cleaner')
      end

      it "strips leading spaces from original_url" do
        url = build(:url, original_url: '  http://www.google.com')
        url.sanitize
        expect(url.original_url).to eq('http://www.google.com')
      end

      it "strips trailing spaces from original_url" do
        url = build(:url, original_url: 'http://www.google.com  ')
        url.sanitize
        expect(url.original_url).to eq('http://www.google.com')
      end

      it "dowcases original_url before saving it as sanitized_url" do
        url = build(:url, original_url: 'Google.com')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

    end
  end

  describe "is valid with the follwing urls:" do

    it "http://www.google.com" do
      url = build(:url, original_url: "http://www.google.com")
      expect(url).to be_valid
    end

    it "http://www.google.com/" do
      url = build(:url, original_url: "http://www.google.com/")
      expect(url).to be_valid
    end

    it "https://www.google.com" do
      url = build(:url, original_url: "https://www.google.com")
      expect(url).to be_valid
    end

    it "https://google.com" do
      url = build(:url, original_url: "https://google.com")
      expect(url).to be_valid
    end

    it "www.google.com" do
      url = build(:url, original_url: "google.com")
      expect(url).to be_valid
    end

    it "google.com" do
      url = build(:url, original_url: "google.com")
      expect(url).to be_valid
    end
  end
end
