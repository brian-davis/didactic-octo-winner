# Hide a null cipher within a list of names using a variable pattern.

require_relative("../ch02/load_dictionary.rb") # :load_strings
WORD_LIST = load_strings() || []

# write a short message and use no punctuation or numbers!
message = "Give your word and we rise".gsub(/\s/, "")

names = load_strings('supporters.txt')

name_list = []

# start list with null word not used in cipher
name_list.push(names[0])

# add letter of null cipher to 2nd letter of name, then 3rd, then repeat
count = 1
for letter in message.chars
  for name in names
    if name.length > 2 && !name_list.include?(name) && (
        (count % 2 == 0 && name[2].downcase == letter.downcase) ||
        (count % 2 != 0 && name[1].downcase == letter.downcase)
       )

      name_list.push(name)
      count += 1
      break
    end # if count
  end # name
end # letter

puts "Your Royal Highness:\nIt is with the greatest pleasure I present the list of noble families who have undertaken to support your cause and petition the usurper for the release of your Majesty from the current tragical circumstances."
puts
puts name_list.map(&:capitalize)

# Your Royal Highness:
# It is with the greatest pleasure I present the list of noble families who have undertaken to support your cause and petition the usurper for the release of your Majesty from the current tragical circumstances.

# Abercrombie
# Agnew
# Akins
# Uva
# Baeling
# Byres
# Ator
# Buchan
# Barclay
# Swanning
# Beofing
# Arbuthnott
# Alder
# Backer
# Ainslie
# Adair
# Dewar
# Beard
# Barn
# Aikenhead
# Anstruther
# Beccing
