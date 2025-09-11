require_relative("../ch02/load_dictionary.rb") # :load_strings
WORD_LIST = ((load_strings() || []) + ['a', 'i']).sort

def counter(arr)
  arr.each.with_object({}) do |c, a|
    a[c] ||= 0
    a[c] += 1
  end
end

# Load files, run filters, allow user to view anagrams by 1st letter.
def main
  name = "tmvoordle" # .downcase
  word_list_ini = load_strings
  trigram_filtered = load_strings(File.join(File.expand_path(__dir__), "least-likely_trigrams.txt"))
  word_list = prep_words(name, word_list_ini)
  filtered_cv_map = cv_map_words(word_list)
  filter_1 = cv_map_filter(name, filtered_cv_map)
  filter_2 = trigram_filter(filter_1, trigram_filtered)
  filter_3 = letter_pair_filter(filter_2)
  view_by_letter(name, filter_3)
end

# Prep word list for finding anagrams.
def prep_words(name, word_list_ini)
  puts "length initial word_list = #{word_list_ini.length}"
  len_name = name.length
  word_list = word_list_ini.map { |word| word.downcase if word.length == len_name }.compact
  puts "Length of new word_list = #{word_list.length}"
  return word_list
end

# Map letters in words to consonants & vowels.
def cv_map_words(word_list)
  vowels = "aeiouy"
  cv_mapped_words = []
  for word in word_list
    tmp = ""
    word.each_char do |c|
      if vowels.include?(c)
        tmp += 'v'
      else
        tmp += 'c'
      end
    end
    cv_mapped_words.push(tmp)
  end

  # determine number of unique c-v patters
  total = Set.new(cv_mapped_words).length
  # target fraction to eliminate
  target = 0.05
  # get number of items in target fraction
  n = (total * target).to_i
  count_pruned = counter(cv_mapped_words).sort_by { |_,v| v * -1 }.take(total - n)
  filtered_cv_map = Set.new
  for pattern, count in count_pruned
    filtered_cv_map.add(pattern)
  end
  puts "length filtered_cv_map = #{filtered_cv_map.length}"
  return filtered_cv_map
end

# Remove permutations of words based on unlikely cons-vowel combos.
def cv_map_filter(name, filtered_cv_map)
  perms = name.chars.permutation.map(&:join)
  puts "length of initial permutations set = #{perms.length}" # 24
  vowels = "aeiouy"
  filter_1 = Set.new
  for candidate in perms
    tmp = ""
    candidate.each_char do |c|
      if vowels.include?(c)
        tmp += 'v'
      else
        tmp += 'c'
      end
    end
    filter_1.add(candidate) if filtered_cv_map.include?(tmp)
  end
  puts "# choices after filter_1 = #{filter_1.length}"
  return filter_1
end

# Remove unlikely trigrams from permutations.
def trigram_filter(filter_1, trigrams_filtered)
  filtered = Set.new
  for candidate in filter_1
    for triplet in trigrams_filtered
      filtered.add(candidate) if candidate.include?(triplet.downcase)
    end
  end
  filter_2 = filter_1 - filtered
  puts "# of choices after filter_2 = #{filter_2.length}"
  return filter_2
end

# Remove unlikely letter-pairs from permutations.
def letter_pair_filter(filter_2)
  filtered = Set.new
  rejects = ['dt', 'lr', 'md', 'ml', 'mr', 'mt', 'mv',
             'td', 'tv', 'vd', 'vl', 'vm', 'vr', 'vt']
  first_pair_rejects = ['ld', 'lm', 'lt', 'lv', 'rd',
                        'rl', 'rm', 'rt', 'rv', 'tl', 'tm']

  for candidate in filter_2
    for r in rejects
      filtered.add(candidate) if candidate.include?(r)
    end

    for fp in first_pair_rejects
      filtered.add(candidate) if candidate.start_with?(fp)
    end
  end

  filter_3 = filter_2 - filtered
  puts("# of choices after filter_3 = #{filter_3.length}")

  if filter_3.include?("voldemort")
    puts "Voldemort found!"
  end

  return filter_3
end

# Filter to anagrams starting with input letter
def view_by_letter(name, filter_3)
  puts "Remaining letters = #{name}"
  puts "Select a starting letter or press Enter to see all: "
  first = gets.chomp

  subset = filter_3.select { |candidate| candidate.start_with?(first) }

  puts subset.sort
  puts "Number of choices starting with #{first} = #{subset.length}"
  puts "Try again? (Press Enter else any other key to Exit):"
  try_again = gets.chomp.downcase
  if try_again == ""
    view_by_letter(name, filter_3)
  else
    exit
  end
end

main()

# 🤖 ch03 $ ruby voldemort_british.rb
# length initial word_list = 45333
# Length of new word_list = 6085
# length filtered_cv_map = 209
# length of initial permutations set = 362880
# # choices after filter_1 = 118800
# # of choices after filter_2 = 671
# # of choices after filter_3 = 248
# Voldemort found!
# Remaining letters = tmvoordle
# Select a starting letter or press Enter to see all:
# t
# tedlormov
# tedmorlov
# tedmorolv
# teldormov
# teldromov
# terldomov
# tevoldorm
# tevoldrom
# toldermov
# toldomerv
# toldremov
# toldrovem
# tolvedmor
# tolvedorm
# tolvedrom
# tolvemord
# tolverdom
# tolvermod
# tomedrolv
# tomeldrov
# tomorldev
# tomoveldr
# tomoverld
# torldemov
# torledmov
# torlovedm
# tormedlov
# tormovedl
# tormoveld
# torolvedm
# treldomov
# trevoldom
# troldemov
# troledmov
# trolovedm
# trolvedmo
# trolvedom
# trolvemod
# tromedlov
# tromovedl
# tromoveld
# troolvedm
# troveldom
# Number of choices starting with t = 43
# Try again? (Press Enter else any other key to Exit):

# Remaining letters = tmvoordle
# Select a starting letter or press Enter to see all:
# m
# medlotrov
# medortolv
# medotrolv
# medrotolv
# meldotrov
# merdotolv
# metoldrov
# modertolv
# modetrolv
# mordetolv
# morldevot
# morldotev
# mortedlov
# mortevold
# mortoldev
# mortolved
# motedrolv
# moteldrov
# motevoldr
# motolderv
# motoldrev
# motolvedr
# motolverd
# motorldev
# motredlov
# motrevold
# motroldev
# motrolved
# motrovedl
# motroveld
# movedlort
# movedlotr
# moveldort
# moveldotr
# moveldrot
# moveltord
# moverldot
# movertold
# movetoldr
# movetorld
# movetrold
# Number of choices starting with m = 41
# Try again? (Press Enter else any other key to Exit):
# a