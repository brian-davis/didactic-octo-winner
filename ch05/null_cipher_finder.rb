# Decode a null cipher based on number of letters after punctuation marks.

PUNCTUATION = <<~TEXT.split(//)
!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
TEXT

DIGIT_CHARS = ("0".."9").to_a

DEFAULT_FILE = "trevanion.txt"

# Load a text file as a string.
def load_text(filename)
  File.read(filename).strip
end

# Solve a null cipher based on number letters after punctuation mark.
# message = null cipher text as string stripped of whitespace
# lookahead = endpoint of range of letters after punctuation mark to examine
def solve_null_cipher(message, lookahead)
  for i in (1..lookahead)
    puts i
    plaintext = ""
    count = 0
    found_first = false

    for char in message.chars
      if PUNCTUATION.include?(char)
        count = 0
        found_first = true
      elsif found_first
        count += 1
      end

      if count == i
        plaintext += char
      end
    end # char
    puts "Using offset of #{i} after punctuation = #{plaintext}"
    puts
  end # i
end

# Load text, solve null cipher.
def main
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

  puts
  puts "ORIGINAL MESSAGE = #{loaded_message}"
  puts
  puts "List of punctuation marks to check = #{PUNCTUATION}"

  message = loaded_message.gsub(/\s/, "")

  lookahead = 0
  loop do
    puts "Maximum number of letters to check after punctuation mark: "
    lookahead = gets.chomp
    if lookahead.chars.all? { |c| DIGIT_CHARS.include?(c) }
      lookahead = lookahead.to_i
      break
    else
      puts "Please input a number"
    end
  end

  puts

  solve_null_cipher(message, lookahead)
end

main()

# Enter full filename for message to translate:

# trevanion.txt

# ORIGINAL MESSAGE = Worthie Sir John: Hope, that is the beste comfort of the afflicted, cannot much, I fear me, help you now.
# That I would saye to you, is this only: if ever I may be able to requite that I do owe you, stand not upon
# asking me. 'Tis not much I can do: but what I can do, bee you verie sure I wille.  I knowe that, if deathe
# comes, if ordinary men fear it, it frights not you, accounting for it for a high honour, to have such a
# rewarde of your loyalty. Pray yet that you may be spared this soe bitter, cup. I fear not that you will
# grudge any sufferings; onlie if bie submission you can turn them away, 'tis the part of a wise man.  Tell
# me, an if you can, to do for you anythinge that you wolde have done. The general goes back on Wednesday.
# Restinge your servant to command.  R.T.

# List of punctuation marks to check = ["!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "@", "[", "]", "^", "_", "`", "{", "|", "}", "~", "\n"]
# Maximum number of letters to check after punctuation mark:
# 3

# 1
# Using offset of 1 after punctuation = HtcIhTiisTbbIiiiatPcIotTatTRRT

# 2
# Using offset of 2 after punctuation = ohafehsftiuekfftcorufnienohe

# 3
# Using offset of 3 after punctuation = panelateastendofchapelslides
