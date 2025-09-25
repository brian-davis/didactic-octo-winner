# Use hill climbing to crack a lock combination.

# Compare items in two lists and count number of matches.
def fitness(combo, attempt)
  combo.zip(attempt).count { |i, j| i == j }
end

# Enter lock combination & run hill climbing algorithm to find solution.
def main
  combination = '6822858902'
  puts "Combination: #{combination}"
  combo = combination.split(//).map(&:to_i)

  # generate guess at combination & grade fitness:
  best_attempt = [0] * combo.length
  best_attempt_grade = fitness(combo, best_attempt)
  count = 0
  while best_attempt != combo
    # crossover
    next_try = best_attempt.dup

    # mutate
    lock_wheel = rand(0...combo.length)
    next_try[lock_wheel] = rand(0..9)

    # grade & select
    next_try_grade = fitness(combo, next_try)
    if next_try_grade > best_attempt_grade
      best_attempt = next_try.dup
      best_attempt_grade = next_try_grade
    end
    puts "#{next_try}, #{best_attempt}"
    count += 1
  end

  puts
  puts "Cracked! #{best_attempt}"
  puts "in #{count} tries!"
end

start_time = Time.now
main()
end_time = Time.now
puts "Runtime for this program was #{end_time - start_time} seconds."