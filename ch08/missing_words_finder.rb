# Find words in haiku corpus missing from cmudict & build exceptions dict.

require_relative("cmudict")
require 'json'

# Carnegie Mellon University Pronouncing Dictionary
CMUDICT =  NLTK::CMUDict.dict

# Open and return training corpus of haiku as a set.
# Extract uniqe words from data file.
def load_haiku(filename)
  File.read(filename)
    .gsub('-', ' ')
    .split(' ')
    .each.with_object(Set.new) { |word, memo| memo.add(word) }
end

# Find and return words in word set missing from cmudict.
def cmudict_missing(word_set)
  exceptions = Set.new
  for word in word_set
    word = word[0...-2] if word.end_with?("'s") # do this first, unlike Python
    word = word.downcase.gsub(/[[:punct:]]/, '') # strips "'", unlike Python
    # FIX: this matches words like "I've" and "don't"

    exceptions.add word if !CMUDICT.include?(word)
  end

  puts "exceptions:"
  puts exceptions.to_a
  puts "Number of unique words in haiku corpus = #{word_set.length}"
  puts "Number of words in corpus not in cmudict = #{exceptions.length}"
  membership = (1 - (exceptions.length.to_f / word_set.length)) * 100

  puts "cmudict membership = %.1f%s" % [membership, '%']

  exceptions
end

# Return dictionary of words and syllable counts from set of words.
def make_exceptions_dict(exceptions_set)
  missing_words = {}
  puts "Input # syllables in word. Mistakes can be corrected at end. "
  for word in exceptions_set
    loop do
      print "Enter number syllables in #{word}: "
      num_sylls = gets.chomp
      if num_sylls.match?(/\A\d+\z/)
        missing_words[word] = num_sylls.to_i
        break # loop
      else
        puts "\tNot a valid answer!"
      end
    end
  end

  puts
  puts missing_words
  puts "Make Changes to Dictionary Before Saving?"
  puts "0 - Exit & Save"
  puts "1 - Add a Word or Change a Syllable Count"
  puts "2 - Remove a Word"

  loop do
    print "Enter choice: "
    choice = gets.chomp
    if choice == "0"
      break # loop
    elsif choice == "1"
      print "Word to add or change: "
      w = gets.chomp
      print "Enter number of syllables in #{w}: "
      n = gets.chomp
      missing_words[w] = n
    elsif choice == "2"
      puts "Enter word to delete: "
      w = gets.chomp
      missing_words.delete(w)
    end
  end

  puts "New words or syllable changes: "
  puts missing_words

  missing_words
end

# Save exceptions dictionary as json file.
def save_exceptions(missing_words)
  json_string = JSON(missing_words)
  File.write('missing_words.json', json_string)
  puts "File saved as missing_words.json"
end

# main()
haiku = load_haiku("train.txt")
exceptions = cmudict_missing(haiku)
puts "Manually build an exceptions dictionary (y/n)?"
build_dict = gets.chomp.downcase
if build_dict == "n"
  exit
else
  missing_words_dict = make_exceptions_dict(exceptions)
  save_exceptions(missing_words_dict)
end