require 'numpy'
require 'matplotlib/pyplot'

require_relative("pylike")
include Pylike::Collections # Counter

np = Numpy
plt = Matplotlib::Pyplot

# Calculate probability of detecting alien radio bubbles in galaxy.

NUM_EQUIV_VOLUMES = 1000  # number of locations in which to place civilizations
MAX_CIVS          = 5000  # maximum number of advanced civilizations
TRIALS            = 1000  # number of times to model a given number of civilizations
CIV_STEP_SIZE     = 100   # civilizations count step size

x = []  # x values for polynomial fit
y = []  # y values for polynomial fit

for num_civs in (2...(MAX_CIVS + 2)).step(CIV_STEP_SIZE)
  civs_per_vol = num_civs.to_f / NUM_EQUIV_VOLUMES
  num_single_civs = 0
  for trial in (0...TRIALS)
    locations = [] # equivalent volumes containing a civilization
    while locations.length < num_civs
      location = rand(1...NUM_EQUIV_VOLUMES)
      locations.push(location)
    end
    overlap_count = Counter[locations]
    overlap_rollup = Counter[overlap_count.values]
    if overlap_rollup[1]
      num_single_civs += overlap_rollup[1]
    else
      raise "data error"
    end
  end
  prob = 1 - (num_single_civs.to_f / (num_civs * TRIALS))
  puts "%.4f %.4f" % [civs_per_vol, prob]

  x.push(civs_per_vol)
  y.push(prob)
end

coefficients = np.polyfit(x, y, 4)
poly = np.poly1d.(coefficients)
puts
puts poly

xp = np.linspace(0, 5)
puts
puts xp

_ = plt.plot(x, y, '.', xp, poly.(xp), "-")
plt.ylim(-0.5, 1.5)
plt.show()

# 🤖 ch10 $ ruby probability_of_detection.rb
# 0.0020 0.0020
# 0.1020 0.0961
# 0.2020 0.1814
# 0.3020 0.2600
# 0.4020 0.3311
# 0.5020 0.3944
# 0.6020 0.4527
# 0.7020 0.5040
# 0.8020 0.5521
# 0.9020 0.5933
# 1.0020 0.6332
# 1.1020 0.6678
# 1.2020 0.6995
# 1.3020 0.7294
# 1.4020 0.7538
# 1.5020 0.7773
# 1.6020 0.7986
# 1.7020 0.8179
# 1.8020 0.8356
# 1.9020 0.8508
# 2.0020 0.8652
# 2.1020 0.8781
# 2.2020 0.8897
# 2.3020 0.8999
# 2.4020 0.9094
# 2.5020 0.9183
# 2.6020 0.9261
# 2.7020 0.9331
# 2.8020 0.9396
# 2.9020 0.9453
# 3.0020 0.9504
# 3.1020 0.9551
# 3.2020 0.9594
# 3.3020 0.9635
# 3.4020 0.9669
# 3.5020 0.9700
# 3.6020 0.9728
# 3.7020 0.9756
# 3.8020 0.9777
# 3.9020 0.9799
# 4.0020 0.9818
# 4.1020 0.9836
# 4.2020 0.9851
# 4.3020 0.9866
# 4.4020 0.9878
# 4.5020 0.9890
# 4.6020 0.9900
# 4.7020 0.9910
# 4.8020 0.9918
# 4.9020 0.9925

#            4           3          2
# -0.004745 x + 0.06667 x - 0.3599 x + 0.9201 x + 0.009527

# [0.         0.10204082 0.20408163 0.30612245 0.40816327 0.51020408
#  0.6122449  0.71428571 0.81632653 0.91836735 1.02040816 1.12244898
#  1.2244898  1.32653061 1.42857143 1.53061224 1.63265306 1.73469388
#  1.83673469 1.93877551 2.04081633 2.14285714 2.24489796 2.34693878
#  2.44897959 2.55102041 2.65306122 2.75510204 2.85714286 2.95918367
#  3.06122449 3.16326531 3.26530612 3.36734694 3.46938776 3.57142857
#  3.67346939 3.7755102  3.87755102 3.97959184 4.08163265 4.18367347
#  4.28571429 4.3877551  4.48979592 4.59183673 4.69387755 4.79591837
#  4.89795918 5.        ]