require "benchmark"

require_relative("load_dictionary.rb") # :load_strings
WORD_LIST = load_strings() || []

# unoptimized
def find_palingrams1
  palingram_list = []

  word_list = WORD_LIST
  # word_list = ["nurses", "run", "stir", "grits", "other", "car", "race"]

  for word in word_list
    # puts "word: #{word}"
    end_index = word.length
    rev_word = word.reverse

    if end_index > 1
      for i in (0...end_index)
        if word[i..-1] == rev_word[0...(end_index - i)] &&
           word_list.include?(rev_word[(end_index - i)..-1])

          palingram_list.push([word, rev_word[(end_index - i)..-1]])
        end

        if word[0..i] == rev_word[(end_index - i)..-1] &&
           word_list.include?(rev_word[0...(end_index - i)])

          palingram_list.push([rev_word[0...(end_index - i)], word])
        end
      end
    end
  end

  palingram_list
end

# optimized
def find_palingrams2
  palingram_list = []

  word_list = WORD_LIST
  # word_list = ["nurses", "run", "stir", "grits", "other", "car", "race"]

  words = {}
  word_list.each do |w|
    words[w] = 1
  end

  for word in word_list
    # puts "word: #{word}"
    end_index = word.length
    rev_word = word.reverse

    if end_index > 1
      for i in (0...end_index)
        if word[i..-1] == rev_word[0...(end_index - i)] &&
           words[rev_word[(end_index - i)..-1]]

          palingram_list.push([word, rev_word[(end_index - i)..-1]])
        end

        if word[0..i] == rev_word[(end_index - i)..-1] &&
           words[rev_word[0...(end_index - i)]]

          palingram_list.push([rev_word[0...(end_index - i)], word])
        end
      end
    end
  end

  palingram_list
end

# # palingrams = find_palingrams2.sort_by { |a, _| a }.map { |e| e.join(" ") }
# # puts "Number of palingrams: #{palingrams.length}"
# # puts palingrams

# Benchmark.bm do |x|
#   x.report("v1") {
#     find_palingrams1
#   }
#   x.report("v2") {
#     find_palingrams2
#   }
# end

# # 🤖 ch02 $ ruby palingrams_optimized.rb
# #         user     system      total        real
# # v1 13.474622   0.021343  13.495965 ( 13.496680)
# # v2  0.200365   0.001108   0.201473 (  0.201471)