# Load ciphertext & use fraction of ETAOIN present to classify cipher type.

# set arbitrary cutoff fraction of 6-most common letters in English
# ciphertext with target fraction or greater = transposition cipher
CUTOFF = 0.5
TARGET = "etaoin"

# load ciphertext
def load(filename)
  File.read(filename).strip
end

def most_common(arr, n)
  histogram = {}
  arr.each do |e|
    histogram[e] ||= 0
    histogram[e] += 1
  end

  histogram.sort_by { |_k, v| v * -1 }.take(n).to_h
end

["cipher_a.txt", "cipher_b.txt"].each do |filename|
  puts
  puts filename

  begin
    ciphertext = load(filename)
  rescue => e
    puts "#{e}. Terminating program"
    exit(1)
  end

  # count 6 most-common letters in ciphertext
  six_most_frequent = most_common(ciphertext.downcase.chars, 6)
  puts "Six most-frequently-used letters in English = ETAOIN"
  puts "Six most frequent letters in ciphertext = #{six_most_frequent}"

  cipher_top_6 = six_most_frequent.keys

  count = 0
  for letter in TARGET.chars
    if cipher_top_6.include?(letter)
      count += 1
    end
  end

  if count.to_f / TARGET.length >= CUTOFF
    puts "This ciphertext most-likely produced by a TRANSPOSITION cipher"
  else
    puts "This ciphertext most-likely produced by a SUBSTITUTION cipher"
  end
end

# cipher_a.txt
# Six most-frequently-used letters in English = ETAOIN
# Six most frequent letters in ciphertext = {"e"=>165, "t"=>126, "a"=>102, "o"=>93, "h"=>80, "r"=>79}
# This ciphertext most-likely produced by a TRANSPOSITION cipher

# cipher_b.txt
# Six most-frequently-used letters in English = ETAOIN
# Six most frequent letters in ciphertext = {"g"=>81, "p"=>77, "c"=>76, "s"=>61, "v"=>60, "r"=>60}
# This ciphertext most-likely produced by a SUBSTITUTION cipher
