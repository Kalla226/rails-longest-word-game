require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times {@letters << Array('A'..'Z').to_a.sample}
  end

  def score
    @score = session[:score]
    session[:score] = 0
    @word = params[:input]
    @grid = params[:letters].split
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    attempt_array = @word.upcase.split('')
    attempt_test = attempt_array.all? { |l| attempt_array.count(l) <= @grid.count(l) }
    if attempt_test == true
      if user['found'] == true
        @score += attempt_array.length
        @result = "Congratulations, #{@word} is a valid english word"
      else
        @score += 0
        @result = "Sorry, but #{@word} does not seem to be a valid english word"
      end
    else
      @result = "Sorry, but #{@word} can´t be built out of #{@grid.join(", ")}"
      @score += 0
    end
    session[:score] += @score
  end
end
