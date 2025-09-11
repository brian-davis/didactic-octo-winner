require_relative("../ch02/load_dictionary.rb") # :load_strings
WORD_LIST = load_strings() || []

# Generate letter pairs in Voldemort & find their frequency in a dictionary.
name = "Voldemort".downcase # tmvoordle

# generate unique letter pairs from name
digrams = Set.new
perms = name.chars.permutation.map(&:join)
for perm in perms
  perm.chars.each_cons(2).map(&:join).each do |e|
    digrams.add(e)
  end
end
digrams = digrams.to_a.sort
puts digrams
puts "Number of digrams: #{digrams.length}"

# used regular expressions to find repeating digrams in a word
mapped = {}
for word in WORD_LIST
  word = word.downcase
  for digram in digrams
    mapped[digram] ||= 0
    mapped[digram] += word.scan(/#{digram}/).count
  end
end

puts "digram frequency count:"
count = 0
for k,v in mapped.sort
  puts "#{k}: #{v}"
end

# 🤖 ch03 $ ruby count_digrams_practice.rb
# de
# dl
# dm
# do
# dr
# dt
# dv
# ed
# el
# em
# eo
# er
# et
# ev
# ld
# le
# lm
# lo
# lr
# lt
# lv
# md
# me
# ml
# mo
# mr
# mt
# mv
# od
# oe
# ol
# om
# oo
# or
# ot
# ov
# rd
# re
# rl
# rm
# ro
# rt
# rv
# td
# te
# tl
# tm
# to
# tr
# tv
# vd
# ve
# vl
# vm
# vo
# vr
# vt
# Number of digrams: 57
# digram frequency count:
# de: 2803
# dl: 319
# dm: 88
# do: 604
# dr: 401
# dt: 17
# dv: 73
# ed: 4732
# el: 2216
# em: 1064
# eo: 272
# er: 7700
# et: 1541
# ev: 570
# ld: 382
# le: 3928
# lm: 138
# lo: 1474
# lr: 26
# lt: 462
# lv: 131
# md: 4
# me: 1948
# ml: 37
# mo: 1037
# mr: 7
# mt: 5
# mv: 5
# od: 598
# oe: 146
# ol: 1310
# om: 1312
# oo: 830
# or: 3059
# ot: 928
# ov: 499
# rd: 675
# re: 5149
# rl: 301
# rm: 631
# ro: 2416
# rt: 1165
# rv: 215
# td: 7
# te: 5023
# tl: 507
# tm: 80
# to: 1624
# tr: 1780
# tv: 8
# vd: 1
# ve: 2089
# vl: 4
# vm: 0
# vo: 301
# vr: 3
# vt: 0
