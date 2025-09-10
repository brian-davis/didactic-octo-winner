def load_strings(filepath)
  File.readlines(filepath).map(&:chomp).map(&:downcase)
rescue => e
  STDERR.puts "Error opening #{filepath}"
  STDERR.puts e.message
end

# dictionary = "/usr/share/dict/words"
# lines = load_strings(dictionary)
# if lines
#   puts "first: #{lines[0]}; last: #{lines[-1]}; linecount: #{lines.count}"
# end

# # first: a; last: zyzzogeton; linecount: 235976