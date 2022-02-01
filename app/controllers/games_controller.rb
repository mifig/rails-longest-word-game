require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []

    10.times do
      @letters << ("A".."Z").to_a.sample
    end
  end

  def score
    @word = params[:word].downcase
    letters = params[:letters].downcase.split
    response = api_call(@word)

    @result = result_string(@word, letters, response)
  end

  private 

  def api_call(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response_serialized = URI.open(url).read
    
    return JSON.parse(response_serialized)
  end

  def result_string(word, letters, response)
    word_check = word.chars.all? { |char| word.count(char) <= letters.count(char) }

    if word_check && response["found"] == true
      result = "Congratulations! #{word.upcase} is a valid English word!"
    elsif word_check
      result = "Sorry, but #{word.upcase} does not seem to be a valid English word..."
    else
      result = "Sorry, but #{word.upcase} can't be built out of #{letters.join(", ").upcase}"
    end

    return result
  end
end
