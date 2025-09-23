require_relative("../ch02/load_dictionary.rb") # :load_strings
WORD_LIST = load_strings() || []
INPUT_MESSAGE = "Panel at east end of chapel slides"
ASCII_LETTERS = ("A".."Z").to_a + ("a".."z").to_a

message = ""
for char in INPUT_MESSAGE.chars
  if ASCII_LETTERS.include?(char)
    message += char
  end
end
puts message

vocab_list = []
for letter in message.chars
  size = rand(6..10)
  # for word in WORD_LIST
  #   if word.length == size &&
  #      word[2].downcase == letter.downcase &&
  #      !vocab_list.include?(word)
  #     vocab_list.push(word)
  #     break
  #   end # if
  # end # word

  match = WORD_LIST.detect do |word|
    word.length == size &&
    word[2].downcase == letter.downcase &&
    !vocab_list.include?(word)
  end
  vocab_list.push(match) if match
end # letter

if vocab_list.length < message.length
  puts "Word List is too small. Try larger dictionary or shorter message!"
else
  puts "Vocabulary words for Unit 1: "
  puts vocab_list
end


# Panelateastendofchapelslides
# Vocabulary words for Unit 1:
# alphabets
# abandoning
# agnostics
# abelian
# allegedly
# abandon
# activating
# aberdeen
# abandoned
# absconding
# activation
# abelson
# abnormally
# abdomens
# abolishers
# affable
# accede
# achievable
# abashed
# alpert
# aberrant
# allegheny
# absent
# ablated
# abided
# abdomen
# abetted
# abscess