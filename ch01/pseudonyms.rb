# Generate funny names by randomly combining names from 2 separate lists.

def main
  # Choose names at random from 2 tuples of names and print to screen.
  puts("Welcome to the Psych 'Sidekick Name Picker.")
  puts("A name just like Sean would pick for Gus:")
  puts

  first = [
    'Baby Oil', 'Bad News', 'Big Burps', "Bill 'Beenie-Weenie'",
    "Bob 'Stinkbug'", 'Bowel Noises', 'Boxelder', "Bud 'Lite'",
    'Butterbean', 'Buttermilk', 'Buttocks', 'Chad', 'Chesterfield',
    'Chewy', 'Chigger', 'Cinnabuns', 'Cleet', 'Cornbread',
    'Crab Meat', 'Crapps', 'Dark Skies', 'Dennis Clawhammer',
    'Dicman', 'Elphonso', 'Fancypants', 'Figgs', 'Foncy', 'Gootsy',
    'Greasy Jim', 'Huckleberry', 'Huggy', 'Ignatious', 'Jimbo',
    "Joe 'Pottin Soil'", 'Johnny', 'Lemongrass', 'Lil Debil',
    'Longbranch', '"Lunch Money"', 'Mergatroid', '"Mr Peabody"',
    'Oil-Can', 'Oinks', 'Old Scratch', 'Ovaltine', 'Pennywhistle',
    'Pitchfork Ben', 'Potato Bug', 'Pushmeet', 'Rock Candy',
    'Schlomo', 'Scratchensniff', 'Scut', "Sid 'The Squirts'",
    'Skidmark', 'Slaps', 'Snakes', 'Snoobs', 'Snorki', 'Soupcan Sam',
    'Spitzitout', 'Squids', 'Stinky', 'Storyboard', 'Sweet Tea',
    'TeeTee', 'Wheezy Joe', "Winston 'Jazz Hands'", 'Worms'
  ]

  last = [
    'Appleyard', 'Bigmeat', 'Bloominshine', 'Boogerbottom',
    'Breedslovetrout', 'Butterbaugh', 'Clovenhoof', 'Clutterbuck',
    'Cocktoasten', 'Endicott', 'Fewhairs', 'Gooberdapple',
    'Goodensmith', 'Goodpasture', 'Guster', 'Henderson', 'Hooperbag',
    'Hoosenater', 'Hootkins', 'Jefferson', 'Jenkins',
    'Jingley-Schmidt', 'Johnson', 'Kingfish', 'Listenbee', "M'Bembo",
    'McFadden', 'Moonshine', 'Nettles', 'Noseworthy', 'Olivetti',
    'Outerbridge', 'Overpeck', 'Overturf', 'Oxhandler', 'Pealike',
    'Pennywhistle', 'Peterson', 'Pieplow', 'Pinkerton', 'Porkins',
    'Putney', 'Quakenbush', 'Rainwater', 'Rosenthal', 'Rubbins',
    'Sackrider', 'Snuggleshine', 'Splern', 'Stevens', 'Stroganoff',
    'Sugar-Gold', 'Swackhamer', 'Tippins', 'Turnipseed', 'Vinaigrette',
    'Walkingstick', 'Wallbanger', 'Weewax', 'Weiners', 'Whipkey',
    'Wigglesworth', 'Wimplesnatch', 'Winterkorn', 'Woolysocks'
  ]

  loop do
    first_name = first.sample
    last_name = last.sample
    puts
    puts "#{first_name} #{last_name}"
    puts "Try again? (Press Enter else n to quit)"
    try_again = gets
    break if try_again.chomp.downcase == "n"
  end

  puts "Press Enter to exit"
  exit if gets.chomp
end

# Python pattern for running as script, not imported module.
# https://stackoverflow.com/a/60179077/21928926
if $PROGRAM_NAME == __FILE__
  # pseudonyms.rb
  main()
end