def load_strings(filepath = nil)
  lines = if filepath
    File.readlines(filepath)
  else
    # default
    filepath = "dictionary.txt"
    File.readlines(File.join(File.expand_path(__dir__), filepath))
  end

  lines.map(&:chomp).map(&:downcase)
rescue => e
  STDERR.puts "Error opening #{filepath}"
  STDERR.puts e.message
end