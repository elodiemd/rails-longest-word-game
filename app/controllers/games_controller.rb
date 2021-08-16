require 'open-uri'
class GamesController < ApplicationController
  VOWELS = ["a", "e", "i", "o", "u", "y"]

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('a'...'z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters]
    @word = params[:word]
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)

    if !@included
      @score = "Sorry but #{@word} can’t be built out of #{@letters}"
    elsif @english_word == false
      @score = "The word is valid according to the grid, but is not a valid English word"
    elsif @english_word
      @score = "Well Done!"
    end
  end

  private

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(word, letters)
    word.chars.all? { |letter| letters.include?(letter) }
  end
end
