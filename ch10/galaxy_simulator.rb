# Build 2D model of galaxy, calculate & post probability of detection.

require "tk"
require "numpy"

# Scale (Radio Bubble Diameter) in Light Years
SCALE = 225  # Enter 225 to see Earth's radio bubble

# Number of advanced alien civilizations
NUM_CIVS = 15600000

# actual Milky Way Dimensions (light-years)
DISC_RADIUS = 50000
DISC_HEIGHT = 1000
DISC_VOL = Math::PI * DISC_RADIUS**2 * DISC_HEIGHT

$root = TkRoot.new {title "Galaxy Simulator"}
$canvas = TkCanvas.new($root) do
  width(1000)
  height(800)
  background("black")
  scrollregion("-500 -400 500 400")
end
$canvas.grid

# Scale galaxy dimensions based on radio bubble size (scale).
def scale_galaxy
  disc_radius_scaled = (DISC_RADIUS.to_f / SCALE).round
  bubble_vol = 4.0 / 3.0 * Math::PI * (SCALE.to_f / 2) ** 3
  disc_vol_scaled = DISC_VOL.to_f / bubble_vol

  [disc_radius_scaled, disc_vol_scaled]
end

# Calculate probability of galactic civilizations detecting each other.
def detect_prob(disc_vol_scaled)
  # ratio of civs to scaled galaxy volume
  ratio = NUM_CIVS.to_f / disc_vol_scaled

  if ratio < 0.002
    # set very low ratios to probability of 0
    detection_prob = 0
  elsif ratio >= 5
    # set high ratios to probability of 1
    detection_prob = 1
  else
    detection_prob = -0.004757 * ratio ** 4 + 0.06681 * ratio ** 3 - 0.3605 * ratio ** 2 + 0.9215 * ratio + 0.00826
  end

  detection_prob.round(3)
end

# Generate uniform random x,y point within a disc for 2-D display.
def random_polar_coordinates(disc_radius_scaled)
  r = rand() # (0..1)
  theta =  Numpy.random.uniform(0, 2 * Math::PI)
  x = (Math.sqrt(r) * Math.cos(theta) * disc_radius_scaled).round
  y = (Math.sqrt(r) * Math.sin(theta) * disc_radius_scaled).round

  [x, y]
end

# Build spiral arms for tkinter display using Logarithmic spiral formula.
# b = arbitrary constant in logarithmic spiral equation
# r = scaled galactic disc radius
# rot_fac = rotation factor
# fuz_fac = random shift in star position in arm, applied to 'fuzz' variable
# arm = spiral arm (0 = main arm, 1 = trailing stars)
def spirals!(b, r, rot_fac, fuz_fac, arm)
  spiral_stars = []
  fuzz = Integer(0.030 * r.abs) # randomly shift star locations
  theta_max_degrees = 520
  for i in (0...theta_max_degrees) # range(0, 600, 2) for no black hole
    theta = Numpy.radians(i)
    x = r * Math.exp(b * theta) * Math.cos(theta + Math::PI * rot_fac) + rand(-fuzz...
    fuzz) * fuz_fac
    y = r * Math.exp(b * theta) * Math.sin(theta + Math::PI * rot_fac) + rand(-fuzz...fuzz) * fuz_fac
    spiral_stars.push([x, y])
  end

  for x, y in spiral_stars
    if arm == 0 && x % 2 == 0
      TkcOval.new($canvas, x - 2, y - 2, x + 2, y + 2, :fill => "white", :outline => "")
    elsif arm == 0 && x % 2 != 0
      TkcOval.new($canvas, x - 1, y - 1, x + 1, y + 1, :fill => "white", :outline => "")
    elsif arm == 1
      TkcOval.new($canvas, x, y, x, y, :fill => "white", :outline => "")
    end
  end
end

# Randomly distribute faint tkinter stars in galactic disc.
# disc_radius_scaled = galactic disc radius scaled to radio bubble diameter
# density = multiplier to vary number of stars posted
def star_haze!(disc_radius_scaled, density)
  for i in (0...(disc_radius_scaled * density))
    x, y = random_polar_coordinates(disc_radius_scaled)
    TkcText.new($canvas, x, y, :text => '.', :font => 'Helvetica', :fill => 'white')
  end
end


### main() ###


# Generate galaxy display, calculate detection probability, post stats.
disc_radius_scaled, disc_vol_scaled = scale_galaxy()
detection_prob = detect_prob(disc_vol_scaled)

# build 4 main spiral arms & 4 trailing arms
spirals!(-0.3, disc_radius_scaled,  2,     1.5, 0)
spirals!(-0.3, disc_radius_scaled,  1.91,  1.5, 1)
spirals!(-0.3, -disc_radius_scaled, 2,     1.5, 0)
spirals!(-0.3, -disc_radius_scaled, -2.09, 1.5, 1)
spirals!(-0.3, -disc_radius_scaled, 0.5,   1.5, 0)
spirals!(-0.3, -disc_radius_scaled, 0.4,   1.5, 1)
spirals!(-0.3, -disc_radius_scaled, -0.5,  1.5, 0)
spirals!(-0.3, -disc_radius_scaled, -0.6,  1.5, 1)
star_haze!(disc_radius_scaled, 8)

# display legend
TkcText.new($canvas, -455, -360, {
  :text => "One Pixel = #{SCALE} LY",
  :anchor => 'w',
  :fill => 'white'
})

TkcText.new($canvas, -455, -330, {
  :text => "Radio Bubble Diameter = #{SCALE} LY",
  :anchor => 'w',
  :fill => 'white'
})

TkcText.new($canvas, -455, -300, {
  :text => "Probability of detection for #{detection_prob} civilizations = #{NUM_CIVS}",
  :anchor => 'w',
  :fill => 'white'
})

# post Earth's 225 LY diameter bubble and annotate
if SCALE == 225
  TkcRectangle.new($canvas, 115, 75, 116, 76, :fill => 'red', :outline => '')
  TkcText.new($canvas, 118, 72, :fill => 'red', :anchor => 'w', text: "← Earth's Radio Bubble")
end

# run tkinter loop
$root.mainloop()