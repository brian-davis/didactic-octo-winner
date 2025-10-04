# Calculate probability of a shared birthday per x number of people.

max_people = 50
num_runs = 2000

puts "Probability of at least 2 people having the same birthday:"

for people in (2..max_people)
  found_shared = 0
  for run in (0...num_runs)
    bdays = []
    for i in (0...people)
      bday = rand(1..365)
      bdays.push(bday)
    end
    if bdays.uniq.length < bdays.length
      found_shared += 1
    end
  end
  prob = (found_shared.to_f / num_runs).round(4)
  puts "Number people = #{people} Prob = #{prob}"
end

# According to the Birthday Paradox, if there are 23 people in a room,
# there's a 50% chance that two of them will share the same birthday.


# Probability of at least 2 people having the same birthday:
# Number people = 2 Prob = 0.003
# Number people = 3 Prob = 0.0075
# Number people = 4 Prob = 0.0165
# Number people = 5 Prob = 0.0325
# Number people = 6 Prob = 0.037
# Number people = 7 Prob = 0.0535
# Number people = 8 Prob = 0.0715
# Number people = 9 Prob = 0.1035
# Number people = 10 Prob = 0.125
# Number people = 11 Prob = 0.139
# Number people = 12 Prob = 0.163
# Number people = 13 Prob = 0.187
# Number people = 14 Prob = 0.2235
# Number people = 15 Prob = 0.257
# Number people = 16 Prob = 0.281
# Number people = 17 Prob = 0.3105
# Number people = 18 Prob = 0.341
# Number people = 19 Prob = 0.3885
# Number people = 20 Prob = 0.3975
# Number people = 21 Prob = 0.4385
# Number people = 22 Prob = 0.475
# Number people = 23 Prob = 0.497
# Number people = 24 Prob = 0.539
# Number people = 25 Prob = 0.5635
# Number people = 26 Prob = 0.6155
# Number people = 27 Prob = 0.6105
# Number people = 28 Prob = 0.672
# Number people = 29 Prob = 0.6775
# Number people = 30 Prob = 0.6985
# Number people = 31 Prob = 0.7345
# Number people = 32 Prob = 0.7475
# Number people = 33 Prob = 0.77
# Number people = 34 Prob = 0.796
# Number people = 35 Prob = 0.813
# Number people = 36 Prob = 0.8325
# Number people = 37 Prob = 0.8535
# Number people = 38 Prob = 0.849
# Number people = 39 Prob = 0.8885
# Number people = 40 Prob = 0.891
# Number people = 41 Prob = 0.9065
# Number people = 42 Prob = 0.9125
# Number people = 43 Prob = 0.9165
# Number people = 44 Prob = 0.933
# Number people = 45 Prob = 0.9475
# Number people = 46 Prob = 0.952
# Number people = 47 Prob = 0.9575
# Number people = 48 Prob = 0.966
# Number people = 49 Prob = 0.967
# Number people = 50 Prob = 0.9715
