# Decrypt a route cipher by inputing matrix & key.
ciphertext = "16 12 8 4 0 1 5 9 13 17 18 14 10 6 2 3 7 11 15 19"

# split elements into words, not letters
cipherlist = ciphertext.split(" ")

COLS = 4
ROWS = 5
key_int = [-1, 2, -3, 4] # neg number means read UP column, vs. DOWN
translation_matrix = Array.new(COLS) { nil }
plaintext = ""
start = 0
stop = ROWS

# turn columns into items in list of lists:
for k in key_int
  slice = cipherlist[start...stop]
  col_items = k.negative? ? slice : slice.reverse
  translation_matrix[k.abs - 1] = col_items
  start += ROWS
  stop += ROWS
end

puts "ciphertext = #{ciphertext}"
puts "translation_matrix = #{translation_matrix}"
puts "key length = #{key_int.length}"

# loop through nested lists popping off last item to new list:
for i in (0...ROWS)
  for col_items in translation_matrix
    word = col_items.pop.to_s
    plaintext += "#{word} "
  end
end

puts "plaintext = #{plaintext}"

# 🤖 ch04 $ ruby route_cypher_decrypt_prototype.rb
# ciphertext = 16 12 8 4 0 1 5 9 13 17 18 14 10 6 2 3 7 11 15 19
# translation_matrix = [["16", "12", "8", "4", "0"], ["17", "13", "9", "5", "1"], ["18", "14", "10", "6", "2"], ["19", "15", "11", "7", "3"]]
# key length = 4
# plaintext = 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19