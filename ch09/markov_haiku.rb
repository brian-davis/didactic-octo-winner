# Produce new haiku from training corpus of existing haiku.

require_relative("../ch08/count_syllables")
include CountSyllables # count_syllables method
require "logger"

LOGGER1 = Logger.new('markov_haiku.log')
LOGGER1.level = Logger::DEBUG

# Return a text file as a string.
def load_training_file(file)
  File.read(file)
end

# Load string, remove newline, split words on spaces, and return list.
def prep_training(raw_haiku)
  raw_haiku.gsub("\n", " ").split(" ")
end

# Load list & use dictionary to map word to word that follows.
def map_word_to_word(corpus)
  dict1_to_1 = {}
  corpus.each_cons(2) do |word, suffix|
    dict1_to_1[word] ||= Set.new
    dict1_to_1[word].add(suffix)
  end
  LOGGER1.debug "map_word_to_word results for \"sake\" = #{dict1_to_1['sake']}"

  dict1_to_1
end

# Load list & use dictionary to map word-pair to trailing word.
def map_2_words_to_word(corpus)
  dict2_to_1 = {}
  corpus.each_cons(3) do |word1, word2, suffix|
    key = word1 + " " + word2
    dict2_to_1[key] ||= Set.new
    dict2_to_1[key].add(suffix)
  end
  LOGGER1.debug "map_2_words_to_word results for \"sake jug\" = #{dict2_to_1['sake jug']}"

  dict2_to_1
end

# Return random word and syllable count from training corpus.
def random_word(corpus)
  word = corpus.sample
  num_syls = count_syllables([word])
  if num_syls > 4
    # try again, recursion
    random_word(corpus)
  else
    LOGGER1.debug "random word & syllables = #{word} #{num_syls}"
    return [word, num_syls]
  end
end

# Return all acceptable words in a corpus that follow a key word or phrase
def word_after(prefix, suffix_map, current_syls, target_syls)
  accepted_words = []
  suffixes = suffix_map[prefix] || []
  LOGGER1.debug "word_after SUFFIXES: #{suffixes}"
  for candidate in suffixes
    num_syls = count_syllables([candidate])
    if current_syls + num_syls <= target_syls
      accepted_words.push(candidate)
    end
  end
  LOGGER1.debug "accepted words after \"#{prefix}\" = #{accepted_words}"
  accepted_words
end

# Build a haiku line from a training corpus and return it.
def haiku_line(suffix_map_1, suffix_map_2, corpus, end_prev_line, target_syls)
  line = "2/3"
  line_syls = 0
  current_line = []

  if end_prev_line.length == 0
    # build first line
    line = "1"
    word, num_syls = random_word(corpus)
    current_line.push(word)
    line_syls += num_syls
    word_choices = word_after(word, suffix_map_1, line_syls, target_syls)

    while word_choices.length == 0
      prefix = corpus.sample
      LOGGER1.debug "new random prefix = #{prefix}"
      word_choices = word_after(word, suffix_map_1, line_syls, target_syls)
    end

    word = word_choices.sample
    num_syls = count_syllables([word])
    LOGGER1.debug "word & syllables = #{word} #{num_syls}"

    line_syls += num_syls
    current_line.push(word)

    if line_syls == target_syls
      end_prev_line += current_line.last(2)
      return [current_line, end_prev_line]
    end
  else
    # build lines 2 & 3
    current_line += end_prev_line
  end

  loop do
    LOGGER1.debug "line = #{line}"
    prefix = current_line[-2] + " " + current_line[-1]
    word_choices = word_after(prefix, suffix_map_2, line_syls, target_syls)
    while  word_choices.length == 0
      index = rand(0...(corpus.length - 2))
      prefix = corpus[index] + " " + corpus[index + 1]
      LOGGER1.debug "new random prefix = #{prefix}"
      word_choices = word_after(prefix, suffix_map_2, line_syls, target_syls)
    end

    word = word_choices.sample
    num_syls = count_syllables([word])
    LOGGER1.debug "Word & syllables = #{word} #{num_syls}"

    if line_syls + num_syls > target_syls
      continue
    elsif line_syls + num_syls < target_syls
      current_line.push(word)
      line_syls += num_syls
    elsif line_syls + num_syls == target_syls
      current_line.push(word)
      break
    end
  end # loop

  end_prev_line = []
  end_prev_line += current_line.last(2)

  if line == '1'
    final_line = current_line.dup
  else
    final_line = current_line[2..-1]
  end

  return final_line, end_prev_line
end

# Give user choice of building a haiku or modifying an existing haiku.
def main

  intro = "A thousand monkeys at a thousand typewriters... or one computer...can sometimes produce a haiku."
  puts
  puts intro

  raw_haiku = load_training_file("../ch08/train.txt")
  corpus = prep_training(raw_haiku)
  suffix_map_1 = map_word_to_word(corpus)
  suffix_map_2 = map_2_words_to_word(corpus)
  # binding.irb
  # raise "TODO"
  final = []

  choice = nil
  while choice != "0"
    prompt = <<~TEXT
    Japanese Haiku Generator
    0 - Quit
    1 - Generate a Haiku poem
    2 - Regenerate Line 2
    3 - Regenerate Line 3
    TEXT
    puts prompt
    puts "Choice: "
    choice = gets.chomp

    if choice == "0"
      puts "Goodbye"
      exit
    elsif choice == "1"
      final = []
      end_prev_line = []
      first_line, end_prev_line1 = haiku_line(suffix_map_1, suffix_map_2, corpus, end_prev_line, 5)
      final.append(first_line)

      line, end_prev_line2 = haiku_line(suffix_map_1, suffix_map_2, corpus, end_prev_line1, 7)
      final.append(line)

      line, _end_prev_line3 = haiku_line(suffix_map_1, suffix_map_2, corpus, end_prev_line2, 5)

      final.append(line)
    elsif choice == "2"
      # regenerate line 2
      if final.nil?
        puts "Please generate a full haiku first (Option 1)"
        continue
      else
        line, end_prev_line2 = haiku_line(suffix_map_1, suffix_map_2, corpus, end_prev_line1, 7)
        final[1] = line
      end
    elsif choice == "3"
      # regenerate line 3
      if final.nil?
        puts "Please generate a full haiku first (Option 1)"
        continue
      else
        line, _end_prev_line3 = haiku_line(suffix_map_1, suffix_map_2, corpus, end_prev_line1, 5)
        final[2] = line
      end
    else
      puts "Sorry, but that isn't a valid choice."
      continue
    end

    puts final.map { |line| line.join(" ").capitalize }.join("\n")
    puts
  end
end

main()

#  $ ruby markov_haiku.rb

# A thousand monkeys at a thousand typewriters... or one computer...can sometimes produce a haiku.
# Japanese Haiku Generator
# 0 - Quit
# 1 - Generate a Haiku poem
# 2 - Regenerate Line 2
# 3 - Regenerate Line 3
# Choice:
# 1
# Temple bell then the
# Bronze gong rang! flower in this
# Solemn darkness one