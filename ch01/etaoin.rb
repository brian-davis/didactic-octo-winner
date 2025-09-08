# Map letters from string into dictionary & print bar chart of frequency.

ALPHABET = ('a'..'z')
def bar_chart(text)
  mapped = {}
  text.each_char do |c|
    c = c.downcase
    if ALPHABET.include?(c)
      mapped[c] ||= []
      mapped[c].push(c)
    end
  end
  mapped.sort_by { |k, _| k }.each do |k, v|
    puts "#{k}: #{v}"
  end
end

english_text = 'Like the castle in its corner in a medieval game, I foresee terrible trouble and I stay here just the same.'
bar_chart(english_text)

# a: ["a", "a", "a", "a", "a", "a", "a"]
# b: ["b", "b"]
# c: ["c", "c"]
# d: ["d", "d"]
# e: ["e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e"]
# f: ["f"]
# g: ["g"]
# h: ["h", "h", "h"]
# i: ["i", "i", "i", "i", "i", "i", "i", "i"]
# j: ["j"]
# k: ["k"]
# l: ["l", "l", "l", "l", "l"]
# m: ["m", "m", "m"]
# n: ["n", "n", "n", "n"]
# o: ["o", "o", "o"]
# r: ["r", "r", "r", "r", "r", "r", "r"]
# s: ["s", "s", "s", "s", "s", "s"]
# t: ["t", "t", "t", "t", "t", "t", "t", "t"]
# u: ["u", "u"]
# v: ["v"]
# y: ["y"]

puts

spanish_text = "Como el castillo en su esquina en un juego medieval, preveo problemas terribles y de todos modos me quedo aquí."
bar_chart(spanish_text)

# a: ["a", "a", "a", "a", "a"]
# b: ["b", "b"]
# c: ["c", "c"]
# d: ["d", "d", "d", "d", "d"]
# e: ["e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e"]
# g: ["g"]
# i: ["i", "i", "i", "i"]
# j: ["j"]
# l: ["l", "l", "l", "l", "l", "l"]
# m: ["m", "m", "m", "m", "m"]
# n: ["n", "n", "n", "n"]
# o: ["o", "o", "o", "o", "o", "o", "o", "o", "o", "o", "o"]
# p: ["p", "p"]
# q: ["q", "q", "q"]
# r: ["r", "r", "r", "r"]
# s: ["s", "s", "s", "s", "s", "s", "s"]
# t: ["t", "t", "t"]
# u: ["u", "u", "u", "u", "u", "u"]
# v: ["v", "v"]
# y: ["y"]