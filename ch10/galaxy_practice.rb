# Use spiral formula to build galaxy display.

require "tk"

root = TkRoot.new { title("Galaxy BR549") }
c = TkCanvas.new(root) do
  width(1000)
  height(800)
  background('black')
  scrollregion("-500 -400 500 400")
end
c.grid()

oval_size = 0

# build spiral arms
num_spiral_stars = 500
angle = 3.5
core_diameter = 120
spiral_stars = []
for i in (0...num_spiral_stars)
  theta = i * angle
  r = Math.sqrt(i) / Math.sqrt(num_spiral_stars)
  spiral_stars.push([r * Math.cos(theta), r * Math.sin(theta)])
end

for x, y in spiral_stars
  x = x * 350 + rand(-5...3)
  y = y * 350 + rand(-5...3)
  oval_size = rand(1...3)

  TkcOval.new(c, x - oval_size, y - oval_size, x + oval_size, y + oval_size, :fill => "white", :outline => "")
end

# build wisps
wisps = []
for i in (0...2000)
  theta = i * angle
  # divide by num_spiral_stars for better dust lanes
  r = Math.sqrt(i) / Math.sqrt(num_spiral_stars)
  spiral_stars.push([r * Math.cos(theta), r * Math.sin(theta)])
end

for x, y in spiral_stars
  x = x * 330 + rand(-15...10)
  y = y * 330 + rand(-15...10)
  h = Math.sqrt(x**2 + y**2)
  if h < 350
    wisps.push([x, y])
    TkcOval.new(c, x - 1, y - 1, x + 1, y + 1, :fill => "white", :outline => "")
  end
end

# build galactic core
core = []
for i in (0...900)
  x = rand(-core_diameter...core_diameter)
  y = rand(-core_diameter...core_diameter)
  h = Math.sqrt(x**2 + y**2)
  if h < core_diameter - 70
    core.push([x, y])
    oval_size = rand(2...4)
    TkcOval.new(c, x - oval_size, y - oval_size, x + oval_size, y + oval_size, :fill => "white", :outline => "")
  elsif h < core_diameter
    core.push([x, y])
    oval_size = rand(0...2)
    TkcOval.new(c, x - oval_size, y - oval_size, x + oval_size, y + oval_size, :fill => "white", :outline => "")
  end
end

root.mainloop()
