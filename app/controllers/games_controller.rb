require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    letter_grid = []
    10.times do
      letter_grid << ('A'..'Z').to_a.sample
    end
    @letters = letter_grid.join(" ")
  end

  def score
    ActionDispatch::Session::CookieStore
    url = "https://wagon-dictionary.herokuapp.com/#{params[:question]}"
    words_serialized = open(url).read
    words_hash = JSON.parse(words_serialized)
    @results = words_hash["found"]
    @present = params[:question].upcase!.chars.all? { |letter| params[:question].count(letter) <= params[:letters].count(letter) }

    if @results == true && @present == true
      @display = "Congratulations! That is a valid answer."
      @thingy = params[:question].split('').count
      session[:score] += params[:question].split('').count
    elsif @results == false
      @display = "Idiot! That's not a word!"
    else
      @display = "That word isn't in the grid, dumb dumb!"
    end
  end
end
