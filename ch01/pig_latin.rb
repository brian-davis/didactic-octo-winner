# Turn a word into its Pig Latin equivalent.

VOWELS = 'aeiouy'

loop do
  puts "Type a word and get its pig Latin translation: "
  word = gets.chomp

  first = word[0]
  rest = word[1..word.length]
  pig_latin = if VOWELS.include?(first)
    word + "way"
  else
    rest + first + "ay"
  end

  puts "#{pig_latin}"

  puts "Try again? (Press Enter else n to stop)"
  try_again = gets
  exit if try_again.chomp.downcase == "n"
end