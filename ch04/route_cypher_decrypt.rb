# Decrypt a path through a Union Route Cipher.

# Designed for whole-word transposition ciphers with variable rows & columns.
# Assumes encryption began at either top or bottom of a column.
# Key indicates the order to read columns and the direction to traverse.
# Negative column numbers mean start at bottom and read up.
# Positive column numbers means start at top & read down.

# Example below is for 4x4 matrix with key -1 2 -3 4.
# Note "0" is not allowed.
# Arrows show encryption route; for negative key values read UP.

#   1   2   3   4
#  ___ ___ ___ ___
# | ^ | | | ^ | | | MESSAGE IS WRITTEN
# |_|_|_v_|_|_|_v_|
# | ^ | | | ^ | | | ACROSS EACH ROW
# |_|_|_v_|_|_|_v_|
# | ^ | | | ^ | | | IN THIS MANNER
# |_|_|_v_|_|_|_v_|
# | ^ | | | ^ | | | LAST ROW IS FILLED WITH DUMMY WORDS
# |_|_|_v_|_|_|_v_|
# START        END

# Required inputs - a text message, # of columns, # of rows, key string

# Prints translated plaintext

#==============================================================================
# USER INPUT:

# the string to be decrypted (type or paste between triple-quotes):
CIPHERTEXT = "16 12 8 4 0 1 5 9 13 17 18 14 10 6 2 3 7 11 15 19"

# number of columns in the transposition matrix:
COLS = 4

# number of rows in the transposition matrix:
ROWS = 5

# key with spaces between numbers; negative to read UP column (ex = -1 2 -3 4):
KEY = " -1 2 -3 4 "

# END OF USER INPUT
#==============================================================================

# Run program and print decrypted plaintext.
def main
  puts
  puts "Ciphertext = #{CIPHERTEXT}"
  puts "Trying #{COLS} columns"
  puts "Trying #{ROWS} rows"
  puts "Trying key = #{KEY}"

  # split elements into words, not letters
  cipherlist = CIPHERTEXT.split(/\s/)

  validate_col_row(cipherlist)
  key_int = key_to_int(KEY)
  translation_matrix = build_matrix(key_int, cipherlist)
  plaintext = decrypt(translation_matrix)
  puts "Plaintext = #{plaintext}"
  puts
end

# Check that input columns & rows are valid vs. message length.
def validate_col_row(cipherlist)
  factors = []
  len_cipher = cipherlist.length
  for i in (2...len_cipher)
    factors.append(i) if len_cipher % i == 0
  end
  puts
  puts "Length of cipher = #{len_cipher}"
  puts "Acceptable column/row values include: #{factors}"
  puts

  if ROWS * COLS != len_cipher
    puts "Error - Input columns & rows not factors of length of cipher. Terminating program."
    exit(1)
  end
end

# Turn key into list of integers & check validity.
def key_to_int(key)
  key_int = key.strip.split(/\s/).map(&:to_i)
  key_int_lo, key_int_hi = key_int.minmax

  if key_int.length != COLS ||
     key_int_lo < -COLS     ||
     key_int_hi > COLS      ||
     key_int.include?(0)

    puts "Error - Problem with key. Terminating."
    exit(1)
  else
    return key_int
  end
end

# Turn every n-items in a list into a new item in a list of lists.
def build_matrix(key_int, cipherlist)
  translation_matrix = Array.new(COLS)
  start = 0
  stop = ROWS
  for k in key_int
    if k < 0
      # read bottom-to-top of column
      col_items = cipherlist[start...stop]
    elsif k > 0
      # read top-to-bottom of columnn
      col_items = cipherlist[start...stop].reverse
    end
    translation_matrix[k.abs - 1] = col_items
    start += ROWS
    stop += ROWS
  end
  translation_matrix
end

# Loop through nested lists popping off last item to a string.
def decrypt(translation_matrix)
  plaintext = ""
  for i in (0...ROWS)
    for matrix_col in translation_matrix
      plaintext += "#{matrix_col.pop} "
    end
  end
  plaintext
end

main()

# 🤖 ch04 $ ruby route_cypher_decrypt.rb

# Ciphertext = 16 12 8 4 0 1 5 9 13 17 18 14 10 6 2 3 7 11 15 19
# Trying 4 columns
# Trying 5 rows
# Trying key =  -1 2 -3 4

# Length of cipher = 20
# Acceptable column/row values include: [2, 4, 5, 10]

# Plaintext = 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19