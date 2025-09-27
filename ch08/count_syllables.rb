# American English syllable counter using NLTK cmudict corpus.
require_relative("cmudict")
require 'json'

module CountSyllables
  # load dictionary of words in haiku corpus but not in cmudict
  MISSING_WORDS = JSON.load_file(File.join(__dir__, "missing_words.json"))
  # Carnegie Mellon University Pronouncing Dictionary
  CMUDICT =  NLTK::CMUDict.dict

  # Use corpora to count syllables in English word or phrase.
  def count_syllables(words)
    num_sylls = 0

    for word in words
      # prep words for cmudict corpus
      word = word.gsub("-", " ")
      word = word[0...-2] if word.end_with?("'s") # do this first, unlike Python
      word = word.downcase.gsub(/[[:punct:]]/, '') # strips "'", unlike Python
      # FIX: this matches words like "I've" and "don't"

      if MISSING_WORDS.include?(word)
        num_sylls += MISSING_WORDS[word]
      else

        # ignore alt. pronunciations
        p1 = CMUDICT.dig(word, 0) || [] # all phonemes
        # syllable phonemes marked with number at end
        num_sylls += p1.count { |pn| pn.match(/\d\z/) }
      end
    end

    num_sylls
  end
end