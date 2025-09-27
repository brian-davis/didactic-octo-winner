require_relative "count_syllables"
include CountSyllables

loop do
  puts "Syllable Counter"
  puts "Enter word or phrase else press Enter to Exit: "
  word = gets.chomp
  if word == ""
    exit
  end

  begin
    num_syllables = count_syllables([word]) # pass array
    print "Number of syllables in #{word} is: #{num_syllables}"
    puts
  rescue => e
    puts "Word not found. Try again."
  end
end

# $ ruby run_count_syllables.rb
# Syllable Counter
# Enter word or phrase else press Enter to Exit:
# star
# Number of syllables in star is: 1
# Syllable Counter
# Enter word or phrase else press Enter to Exit:
# eat
# Number of syllables in eat is: 1
# Syllable Counter
# Enter word or phrase else press Enter to Exit:
# freedom
# Number of syllables in freedom is: 2
# Syllable Counter
# Enter word or phrase else press Enter to Exit:
# tremendous
# Number of syllables in tremendous is: 3
# Syllable Counter
# Enter word or phrase else press Enter to Exit:
