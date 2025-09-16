# Encrypt a Civil War 'rail fence' type cipher.
# This is for a "2-rail" fence cipher for short messages
# Example text to encrypt:  'Buy more Maine potatoes'
# Rail fence style:  B Y O E A N P T T E
#                     U M R M I E O A O S
# Read zig-zag:      \/\/\/\/\/\/\/\/\/\/
# Encrypted:  BYOEA NPTTE UMRMI EOSOS

# USER INPUT:
# the string to be encrypted (paste between quotes):
PLAINTEXT = "Let us cross over the river and rest under the shade of the trees1"

# Run program to encrypt message using 2-rail rail fence cipher.
def main
  message = prep_plaintext(PLAINTEXT)
  rails = build_rails(message)
  ciphertext = encrypt(rails)
  puts ciphertext
end

# Remove spaces & leading/trailing whitespace.
def prep_plaintext(plaintext)
  message = plaintext.strip.split(/\s/).join
  message.upcase!
  puts "plaintext = #{plaintext}"

  message
end

# Build strings with every other letter in a message.
def build_rails(message)
  evens = message.chars.select.with_index { |_, i| i.even? }.join
  odds = message.chars.select.with_index { |_, i| i.odd? }.join
  rails = evens + odds

  rails
end

# Split letters in ciphertext into chunks of 5 & join to make string.
def encrypt(rails)
  (0...rails.length).step(5).map { |i| rails[i...i+5] }.join(" ")
end

main()

# plaintext = Let us cross over the river and rest under the shade of the trees
# LTSRS OETEI EADET NETEH DOTER EEUCO SVRHR VRNRS UDRHS AEFHT ES

# # odd number of characters:
# plaintext = Let us cross over the river and rest under the shade of the trees1
# LTSRS OETEI EADET NETEH DOTER E1EUC OSVRH RVRNR SUDRH SAEFH TES