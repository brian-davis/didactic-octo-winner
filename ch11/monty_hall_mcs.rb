# Use Monte Carlo simulation to find correct response to Monty Hall Problem.

# Allow use of default values in input.
def user_prompt(prompt, default=nil)
  prompt = "#{prompt} [#{default}]:"
  puts prompt
  response = gets.chomp
  !response.empty? ? response : default
end

# input number of times to run simulation
num_runs = Integer(user_prompt("Input number of runs", "20000"))

# declare counters for ways to win
first_choice_wins = 0
pick_change_wins = 0
doors = ["a", "b", "c"]

# run Monte Carlo
for i in (0...num_runs)
  winner = doors.sample
  pick = doors.sample

  if pick == winner
    first_choice_wins += 1
  else
    pick_change_wins += 1
  end
end

puts "Wins with original pick = #{first_choice_wins}"
puts "Wins with changed pick = #{pick_change_wins}"

fc_prob = (first_choice_wins.to_f / num_runs).round(2)
puts "Probability of winning with initial guess: #{fc_prob}"

pc_prob = (pick_change_wins.to_f / num_runs).round(2)
puts "Probability of winning by switching: #{pc_prob}"

# 🤖 ch11 $ ruby monty_hall_mcs.rb
# Input number of runs [20000]:

# Wins with original pick = 6750
# Wins with changed pick = 13250
# Probability of winning with initial guess: 0.34
# Probability of winning by switching: 0.66