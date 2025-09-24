require_relative("py_like")

# Use genetic algorithm to simulate breeding race of super rats.

# CONSTANTS (weights in grams)
GOAL = 50000
NUM_RATS = 20  # number of adult breeding rats in each generation
INITIAL_MIN_WEIGHT = 200
INITIAL_MAX_WEIGHT = 600
INITIAL_MODE_WEIGHT = 300
MUTATE_ODDS = 0.01
MUTATE_MIN = 0.5
MUTATE_MAX = 1.2
LITTER_SIZE = 8
LITTERS_PER_YEAR = 10
GENERATION_LIMIT = 500

# ensure even-number of rats for breeding pairs:
if NUM_RATS % 2 != 0
  raise "NUM_RATS must be an even number"
end

# Initialize a population with a triangular distribution of weights.
def populate(num_rats, min_weight, max_weight, mode_weight)
  num_rats.times.map do |_|
    PyLike.random_triangular(min_weight, max_weight, mode_weight)
  end
end

# Measure population fitness based on an attribute mean vs target.
def fitness(population, goal)
  average = PyLike.mean(population)
  average / goal
end

# Cull a population to contain only a specified number of members.
def select(population, to_retain)
  sorted_population = population.sort
  to_retain_by_sex = to_retain / 2 # integer division
  members_per_sex = sorted_population.length / 2
  females = sorted_population[0...members_per_sex]
  males = sorted_population[members_per_sex...sorted_population.length]
  selected_females = females[-to_retain_by_sex...females.length]
  selected_males = males[-to_retain_by_sex...males.length]

  [selected_males, selected_females]
end

# Crossover genes among members of a population.
def breed(males, females, litter_size)
  males.shuffle!
  females.shuffle!

  children = []
  for male, female in males.zip(females)
    for child in (0...litter_size)
      child = rand(female..male) # or ... ?
      children.push(child)
    end
  end
  children
end

# Randomly alter rat weights using input odds & fractional changes.
def mutate(children, mutate_odds, mutate_min, mutate_max)
  children.each.with_index do |rat, index|
    if mutate_odds >= rand()
      children[index] = (rat * rand(mutate_min..mutate_max)).round
    end
  end

  children
end

# Initialize population, select, breed, and mutate, display results.
def main
  generations = 0
  parents = populate(NUM_RATS, INITIAL_MIN_WEIGHT, INITIAL_MAX_WEIGHT, INITIAL_MODE_WEIGHT)
  puts("Initial population weights = #{parents}")
  popl_fitness = fitness(parents, GOAL)
  puts "Initial population fitness = #{popl_fitness}"
  puts "Number to retain = #{NUM_RATS}"

  average_weight = []

  while popl_fitness < 1 && generations < GENERATION_LIMIT
    selected_males, selected_females = select(parents, NUM_RATS)
    children = breed(selected_males, selected_females, LITTER_SIZE)
    children = mutate(children, MUTATE_ODDS, MUTATE_MIN, MUTATE_MAX)
    parents = selected_males + selected_females + children
    popl_fitness = fitness(parents, GOAL)
    puts "Generation #{generations} fitness  = #{popl_fitness.round(4)}"
    average_weight.push(PyLike.mean(parents).to_int)
    generations += 1
  end

  puts "Average weight per generation = #{average_weight}"
  puts "Number of generations = #{generations}"
  puts "Number of years = #{(generations / LITTERS_PER_YEAR).to_int}"
end

start_time = Time.now
main()
end_time = Time.now
duration = end_time - start_time
puts "Runtime for this program was #{duration} seconds."