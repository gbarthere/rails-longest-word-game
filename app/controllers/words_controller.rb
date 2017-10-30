require 'open-uri'
require 'json'

class WordsController < ApplicationController

# def generate_grid(grid_size)
#    # TODO: generate random grid of letters
#    array = ("A".."Z").to_a
#    grid_size.times.map { array.sample }
#  end
#
#  def run_game(attempt, grid, start_time, end_time)
#  # TODO: runs the game and return detailed hash of result
#    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
#    user_serialized = open(url).read
#    user = JSON.parse(user_serialized)
#  
#    if user["found"] == false
#      message = "Not an english word"
#      score = 0
#    elsif attempt.upcase!.split('').all? { |e| grid.include?(e) & grid.delete(e) } == false
#      message = "Not in the grid"
#      score = 0
#    else
#      message = "Well done!"
#      time = end_time - start_time
#      score = (user["length"] - time) * 1000
#    end
#    { time: time, message: message, score: score }
#  end 

def generate_grid(grid_size)
  Array.new(grid_size) { ('A'..'Z').to_a.sample }
end

def included?(guess, grid)
  guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
end

def compute_score(attempt, time_taken)
  time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
end

def run_game(attempt, grid, start_time, end_time)
  result = { time: end_time - start_time }

  score_and_message = score_and_message(attempt, grid, result[:time])
  result[:score] = score_and_message.first
  result[:message] = score_and_message.last

  result
end

def score_and_message(attempt, grid, time)
  if included?(attempt.upcase, grid)
    if english_word?(attempt)
      score = compute_score(attempt, time)
      [score, "well done"]
    else
      [0, "not an english word"]
    end
  else
    [0, "not in the grid"]
  end
end

def english_word?(word)
  response = open("https://wagon-dictionary.herokuapp.com/#{word}")
  json = JSON.parse(response.read)
  return json['found']
end

  def game
    $time_start = Time.now
    $grid = generate_grid(9)
  end

  def score
    $time_end = Time.now
    $word = params[:word]
    @result = run_game($word, $grid, $time_start, $time_end)
  end

end
