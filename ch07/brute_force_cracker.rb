require_relative("../ch04/perms.rb")
# Use brute force to crack a lock combination.

start_time = Time.now
combo = [9,9,7,6,5]
DIGITS = (0..9).to_a
Perms.py_product_repeat(DIGITS, combo.length).each do |perm|
  puts perm.inspect
  if perm == combo
    puts "Cracked! #{combo} #{perm}"
    break
  end
end

end_time = Time.now
puts "Runtime for this program was #{end_time - start_time} seconds."