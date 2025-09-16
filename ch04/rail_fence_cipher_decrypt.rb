# Decrypt a Civil War 'rail fence' type cipher.
# This is for a "2-rail" fence cipher for short messages
# Example plaintext:  'Buy more Maine potatoes'
# Rail fence style:  B Y O E A N P T T E
#                     U M R M I E O A O S
# Read zig-zag:      \/\/\/\/\/\/\/\/\/\/
# Ciphertext:  BYOEA NPTTE UMRMI EOSOS

# USER INPUT:
# the string to be decrypted (paste between quotes):
# CIPHERTEXT = "LTSRS OETEI EADET NETEH DOTER EEUCO SVRHR VRNRS UDRHS AEFHT ES"

# odd number of characters:
CIPHERTEXT = "LTSRS OETEI EADET NETEH DOTER E1EUC OSVRH RVRNR SUDRH SAEFH TES"

# Run program to decrypt 2-rail rail fence cipher.
def main
  message = prep_ciphertext(CIPHERTEXT)
  row1, row2 = split_rails(message)
  decrypted = decrypt(row1, row2)
  puts decrypted
end

# Remove whitespace.
def prep_ciphertext(ciphertext)
  puts "ciphertext = #{ciphertext}"
  ciphertext.split(/\s/).join
end

# Split message in two, always rounding UP for 1st row.
def split_rails(message)
  len = message.length
  row1_len = len.odd? ? ((len / 2) + 1) : (len / 2)
  row1 = message[0...row1_len]
  row2 = message[row1_len...len]

  [row1, row2]
end

# Build list with every other letter in 2 strings & print.
def decrypt(row1, row2)
  puts "rail 1 = #{row1}"
  puts "rail 2 = #{row2}"
  row1.chars.zip(row2.chars).flatten.join
end

main()

# ciphertext = LTSRS OETEI EADET NETEH DOTER EEUCO SVRHR VRNRS UDRHS AEFHT ES
# rail 1 = LTSRSOETEIEADETNETEHDOTERE
# rail 2 = EUCOSVRHRVRNRSUDRHSAEFHTES
# LETUSCROSSOVERTHERIVERANDRESTUNDERTHESHADEOFTHETREES

# # odd number of characters:
# ciphertext = LTSRS OETEI EADET NETEH DOTER E1EUC OSVRH RVRNR SUDRH SAEFH TES
# rail 1 = LTSRSOETEIEADETNETEHDOTERE1
# rail 2 = EUCOSVRHRVRNRSUDRHSAEFHTES
# LETUSCROSSOVERTHERIVERANDRESTUNDERTHESHADEOFTHETREES1