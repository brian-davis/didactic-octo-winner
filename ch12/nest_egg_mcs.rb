# Retirement nest egg calculator using Monte Carlo simulation.

require 'numpy'
require 'matplotlib/pyplot'
plt = Matplotlib::Pyplot

# Open a file of data in percent, convert to decimal & return a list.
def read_to_list(file_name)
  File.readlines(file_name)
    .map(&:strip).map(&:to_f)
    .map { |line| (line / 100).round(5) }
end

# Allow use of default values in input
def default_input(prompt, default = nil)
  puts "#{prompt} [#{default}]: "
  response = gets.chomp()
  return default if response.empty? && default

  response
end

# load data files with original data in percent form
puts("\nNote: Input data should be in percent, not decimal!")

begin
  bonds = read_to_list('data/10-yr_TBond_returns_1926-2013_pct.txt')
  stocks = read_to_list('data/SP500_returns_1926-2013_pct.txt')
  blend_40_50_10 = read_to_list('data/S-B-C_blend_1926-2013_pct.txt')
  blend_50_50 = read_to_list('data/S-B_blend_1926-2013_pct.txt')
  $infl_rate = read_to_list('data/annual_infl_rate_1926-2013_pct.txt')
rescue => e
  puts "#{e.message}. \nTerminating program."
  exit(1)
end

# get user input; use dictionary for investment-type arguments
investment_type_args = {
  'bonds' => bonds,
  'stocks' => stocks,
  'sb_blend' => blend_50_50,
  'sbc_blend' => blend_40_50_10
}

# print input legend for user
puts("   stocks = SP500")
puts("    bonds = 10-yr Treasury Bond")
puts(" sb_blend = 50% SP500/50% TBond")
puts("sbc_blend = 40% SP500/50% TBond/10% Cash")
puts("Press ENTER to take default value shown in [brackets].")

class String
  def digit?
    match?(/\A\d+\z/)
  end
end

class Integer
  def thousands_separator(sep = ",")
    to_s.gsub(/(?<=\d)(?=(?:\d{3})+\z)/, sep)
  end
end

# REFACTOR: Python-style global vars, encapsulation

# get user input
INT_PROMPT = "Invalid input! Input integer only: "

prompt = "Enter investment type: (stocks, bonds, sb_blend, sbc_blend):"
invest_type = ""
until investment_type_args.key?(invest_type)
  puts prompt
  invest_type = gets.chomp.downcase()
  invest_type = "bonds" if invest_type.empty?
  prompt = "Invalid investment. Enter investment type as listed in prompt: "
end
$invest_type = invest_type

prompt = "Input starting value of investments:"
start_value = ""
until start_value.digit?
  puts prompt
  start_value = gets.chomp.downcase()
  start_value = "2000000" if start_value.empty?
  prompt = INT_PROMPT
end
$start_value = start_value.to_i

prompt = "Input annual pre-tax withdrawal (today's $):"
withdrawal = ""
until withdrawal.digit?
  puts prompt
  withdrawal = gets.chomp.downcase()
  withdrawal = "80000" if withdrawal.empty?
  prompt = INT_PROMPT
end
$withdrawal = withdrawal.to_i

prompt = "Input minimum years in retirement:"
min_years = ""
until min_years.digit?
  puts prompt
  min_years = gets.chomp.downcase()
  min_years = "18" if min_years.empty?
  prompt = INT_PROMPT
end
$min_years = min_years.to_i

prompt = "Input most-likely years in retirement:"
most_likely_years = ""
until most_likely_years.digit?
  puts prompt
  most_likely_years = gets.chomp.downcase()
  most_likely_years = "25" if most_likely_years.empty?
  prompt = INT_PROMPT
end
$most_likely_years = most_likely_years.to_i

prompt = "Input maximum years in retirement:"
max_years = ""
until max_years.digit?
  puts prompt
  max_years = gets.chomp.downcase()
  max_years = "40" if max_years.empty?
  prompt = INT_PROMPT
end
$max_years = max_years.to_i

prompt = "Input number of cases to run:"
num_cases = ""
until num_cases.digit?
  puts prompt
  num_cases = gets.chomp.downcase()
  num_cases = "50000" if num_cases.empty?
  prompt = INT_PROMPT
end
$num_cases = num_cases.to_i

# check for other erroneous input
if !($min_years..$max_years).cover?($most_likely_years) || $max_years > 99
  STDERR.puts("Problem with input years.")
  STDERR.puts("Requires Min < ML < Max & Max <= 99.")
  sys.exit(1)
end

# Run MCS and return investment value at end-of-plan and bankrupt count.
def montecarlo(returns)
  bankrupt_count = 0
  outcome = []

  $num_cases.times do
    investments = $start_value
    start_year = rand(0...returns.length)

    # (left, mode, right, size=None)
    duration = Numpy.random.triangular($min_years, $most_likely_years, $max_years).to_i
    end_year = start_year + duration
    lifespan = (start_year...end_year).to_a
    bankrupt = false

    # build temporary lists for each case
    lifespan_returns = lifespan.map { |i| returns[(i % returns.length)] }
    lifespan_infl = lifespan.map { |i| $infl_rate[(i % $infl_rate.length)] }


    withdraw_infl_adj = 0 # will be reset on 1st iteration (avoid bad self-referrential pattern)

    # loop through each year of retirement for each case run
    lifespan_returns.each.with_index do |n, i|
      infl = lifespan_infl[i]
      # don't adjust for inflation the first year

      withdraw_infl_adj = n == 0 ? $withdrawal : (withdraw_infl_adj * (1 + infl))

      investments -= withdraw_infl_adj
      investments = (investments * (1 + n)).to_i

      if investments <= 0
        bankrupt = true
        break
      end # if
    end # n, i

    if bankrupt
      outcome.push(0)
      bankrupt_count += 1
    else
      outcome.push(investments)
    end
  end # num_cases
  return [outcome, bankrupt_count]
end # montecarlo

# Calculate and return chance of running out of money & other stats.
def bankrupt_prob(outcome, bankrupt_count)
  total = outcome.length
  odds = (100 * bankrupt_count.to_f / total).round(1)
  average_outcome = (outcome.sum.to_f / total).to_i

  puts
  puts "Investment type: #{$invest_type}"
  puts "Starting value: $#{$start_value.thousands_separator}"
  puts "Annual withdrawal: $#{$withdrawal.thousands_separator}"
  puts "Years in retirement (min-ml-max): #{$min_years}-#{$most_likely_years}-#{$max_years}"
  puts "Number of runs: #{outcome.length.thousands_separator}"
  puts "Odds of running out of money: #{odds}%"
  puts "Average outcome: $#{average_outcome}"
  puts "Minimum outcome: $#{outcome.min.thousands_separator}"
  puts "Maximum outcome: $#{outcome.max.thousands_separator}"

  return odds
end

# main()

# Call MCS & bankrupt functions and draw bar chart of results.
outcome, bankrupt_count = montecarlo(investment_type_args[invest_type])
odds = bankrupt_prob(outcome, bankrupt_count)

# generate matplotlib bar chart
plotdata = outcome.first(3000) # only plot first 3000 runds
fig_str = "Outcome by Case (showing first #{plotdata.length} runs)"
plt.figure(fig_str, figsize: [16, 5]) # size is width, height in inches
index = (1..plotdata.length).to_a
plt.bar(index, plotdata, color: "black")
plt.xlabel("Simulated Lives", fontsize: 18)
plt.ylabel("$ Remaining", fontsize: 18)
plt.ticklabel_format(style: "plain", axis: "y")
ax = plt.gca()

formatter_callback = ->(x, _loc) { x.to_i.thousands_separator }
# binding.irb
ax.get_yaxis.set_major_formatter(plt.FuncFormatter.(formatter_callback))

title_str = "Probability of running out of money = #{odds}%"
plt.title(title_str, fontsize: 20, color: "red")
plt.show()


# 🤖 ch12 $ ruby nest_egg_mcs.rb

# Note: Input data should be in percent, not decimal!
#    stocks = SP500
#     bonds = 10-yr Treasury Bond
#  sb_blend = 50% SP500/50% TBond
# sbc_blend = 40% SP500/50% TBond/10% Cash
# Press ENTER to take default value shown in [brackets].
# Enter investment type: (stocks, bonds, sb_blend, sbc_blend):

# Input starting value of investments:

# Input annual pre-tax withdrawal (today's $):

# Input minimum years in retirement:

# Input most-likely years in retirement:

# Input maximum years in retirement:

# Input number of cases to run:


# Investment type: bonds
# Starting value: $2,000,000
# Annual withdrawal: $80,000
# Years in retirement (min-ml-max): 18-25-40
# Number of runs: 50,000
# Odds of running out of money: 0.0%
# Average outcome: $9131961
# Minimum outcome: $2,626,375
# Maximum outcome: $44,094,574