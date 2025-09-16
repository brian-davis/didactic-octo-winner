# Input cipher key string, get user input on route direction as dict value.

COL_ORDER = "1 3 4 2"

key = {}
cols = COL_ORDER.split(/\s/).map(&:to_i)

for col in cols
  loop do
    puts "Direction to read Column #{col} (u = up, d = down): "
    key[col] = gets.chomp.downcase
    if key[col] == "u" || key[col] == "d"
      break
    else
      puts "Input should be 'u' or 'd'"
    end
  end
  puts "#{col}, #{key[col]}"
end

# Direction to read Column 1 (u = up, d = down):
# u
# 1, u
# Direction to read Column 3 (u = up, d = down):
# d
# 3, d
# Direction to read Column 4 (u = up, d = down):
# u
# 4, u
# Direction to read Column 2 (u = up, d = down):
# d
# 2, d