# Solve a null cipher based on every nth-letter in every nth-word.

# Load a text file as a string.
def load_text(filename)
  File.read(filename).strip
end

DEFAULT_FILE = "colchester_message.txt"

puts
puts "Enter full filename for message to translate: "
filename = gets.chomp&.strip
filename = DEFAULT_FILE if filename == ""
puts filename
begin
  loaded_message = load_text(filename)
rescue => e
  puts "#{e.message}. Terminating program."
  exit(1)
end

puts loaded_message

# convert message to list and get length
message = loaded_message.split(/\s/).select { |w| w.length > 0 }

puts "Input max word & letter position to check (e.g., every 1 of 1, 2 of 2, etc.): "

increment = gets.chomp.to_i

# find letters at designated intervals
for i in (1..increment)
  puts "Using increment letter #{i} of word #{i}"
  puts
  count = i - 1
  location = i - 1
  message.each.with_index do |word, index|
    # puts "word: #{word}"
    if index == count
      if location < word.length
        puts "letter = #{word[location]}"
        count += i
      else
        STDERR.puts "Interval doesn't work"
      end
    end
  end
end # i

# Enter full filename for message to translate:

# colchester_message.txt
# Sir John:  Odd and too hard, your lot.  Still, we will band together and, like you, persevere.
# Who else could love their enemies, stand firm when all others fail, hate and despair?
# While we all can, let us feel hope. -R.T.
# Input max word & letter position to check (e.g., every 1 of 1, 2 of 2, etc.):
# 3

# ...

# Using increment letter 3 of word 3

# letter = d
# letter = r
# letter = i
# letter = n
# letter = k
# letter = o
# letter = v
# letter = a
# letter = l
# letter = t
# letter = i
# letter = n
# letter = e