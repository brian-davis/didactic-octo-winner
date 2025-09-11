require_relative("load_dictionary.rb") # :load_strings

word_list = load_strings() || []
palindrome_list = word_list.select { |w| w.length > 1 && w == w.reverse }.uniq
puts "Number of palindromes found: #{palindrome_list.length}"
puts palindrome_list
