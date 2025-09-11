require_relative("../ch02/load_dictionary.rb")
WORD_LIST = ((load_strings() || []) + ['a', 'i']).sort

def counter(string)
  string.each_char.with_object({}) do |c, a|
    a[c] ||= 0
    a[c] += 1
  end
end

def find_anagrams(name, word_list)
  name_letter_map = counter(name)
  anagrams = []
  for word in word_list
    test = ''
    word_letter_map = counter(word.downcase)
    word.each_char do |c|
      if (word_letter_map[c] || 0) <= (name_letter_map[c] || 0)
        test += c
      end
    end
    if counter(test) == word_letter_map
      anagrams.push(word)
    end
  end
  puts anagrams
  puts
  puts "Remaining letters = #{name}"
  puts "Number of remaining letters = #{name.length}"
  puts "Number of remaining (real world) anagrams = #{anagrams.length}"
end

def process_choice(name)
  while true
    puts "Make a choice else Enter to start over or # to end: "
    choice = gets.chomp
    if choice == ''
      main() # ?
    elsif choice == '#'
      exit
    else
      candidate = choice.downcase.gsub(' ', '')
    end
    left_over_list = name.chars
    candidate.each_char do |c|
      if left_over_list.include?(c)
        left_over_list.delete(c)
      end
    end
    if name.length - left_over_list.length == candidate.length
      break
    else
      puts "Won't work! Make another choice!"
    end
  end
  name = left_over_list.join("") # .gsub(' ', '')
  return [choice, name]
end

def main
  puts "Enter a name: "
  name = gets.chomp.downcase.gsub('-', '').gsub(' ', '')
  limit = name.length
  phrase = ''
  running = true

  while running
    tmp_phrase = phrase.gsub(' ', '')
    if tmp_phrase.length < limit
      puts "Length of anagram phrase = #{tmp_phrase.length}"

      find_anagrams(name, WORD_LIST)
      puts "Current anagram phrase: #{phrase}"
      choice, name = process_choice(name)
      phrase += choice + " "

    elsif tmp_phrase.length == limit
      puts "FINISHED"
      puts "Anagram of name: #{phrase}"
      puts
      puts "Try again? (Press Enter else 'n' to quit)"
      try_again = gets.chomp.downcase
      if try_again == "n"
        running = false
        exit
      else
        main() # ?
      end
    end
  end
end

main()

# 🤖 ch03 $ ruby phrase_anagrams.rb
# Enter a name:
# Bill Bo
# Length of anagram phrase = 0
# bib
# bilbo
# bill
# blob
# bob
# boil
# boll
# i
# ill
# oil

# Remaining letters = billbo
# Number of remaining letters = 6
# Number of remaining (real world) anagrams = 10
# Current anagram phrase:
# Make a choice else Enter to start over or # to end:
# ill
# Length of anagram phrase = 3
# bob

# Remaining letters = bbo
# Number of remaining letters = 3
# Number of remaining (real world) anagrams = 1
# Current anagram phrase: ill
# Make a choice else Enter to start over or # to end:
# bob
# FINISHED
# Anagram of name: ill bob

# Try again? (Press Enter else 'n' to quit)
# n