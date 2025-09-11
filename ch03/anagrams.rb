require_relative("../ch02/load_dictionary.rb")
WORD_LIST = load_strings() || []

anagram_list = []
name = "Foster"
puts "Input name: #{name}"
name.downcase!
puts "using name: #{name}"

name_sorted = name.chars.sort

for word in WORD_LIST
  if word != name
    if word.downcase.chars.sort == name_sorted
      anagram_list.push(word)
    end
  end
end

if anagram_list.length == 0
  puts "You need a larger dictionary or a new name!"
else
  puts "Anagrams: "
  puts anagram_list
end

# Input name: Foster
# using name: foster
# Anagrams:
# forest
# softer