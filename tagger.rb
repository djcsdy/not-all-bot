require 'engtagger'

tagger = EngTagger.new

STDIN.read.split("\n").each do |line|
  tagged = tagger.get_readable(line)
  
  next if !tagged
  
  match = tagged.match(/\b(?i:all)\/DET\s+(?:\w+\/JJ\s+)*(\w+)\/NNS\b/)
  
  next if !match
  
  noun = match[1]
  
  next if !noun
  
  puts line
  puts " -> Not ALL #{noun}!"
  puts
end
