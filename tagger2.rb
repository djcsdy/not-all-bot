require 'twitter_ebooks'

tagger = Ebooks::NLP.tagger

STDIN.read.split("\n").each do |line|
  match = line.match(/^(\w+): (.*)$/)
  
  next if !match
  
  screen_name = match[1]
  text = match[2]
  
  # Skip soft-retweets
  next if text.match(/^[RM]T/)
  
  # Strip out leading Twitter handles
  text = text.sub(/^(?:@\w+ )+/, "")
  
  # Grammar/spell-correct text
  corrections = Ebooks::NLP.gingerice.parse(text)
  text = corrections["result"] if corrections
  
  # Skip tweets that already say "not all" in them
  next if text.match(/\bnot\s+all\b/i)
  
  # Avoid interacting with angry and/or bigoted people
  next if text.match(/fuck|nigger|nigga|bitch/i)
  
  # Avoid sensitive subjects
  next if text.match(/\brape\b|\brapist/)
  
  # Tag the tweet with part-of-speech tags
  tagged = tagger.get_readable(text)
  
  # Skip tweets if we can't apply part-of-speech tags
  next if !tagged
  
  # Match [adjective|noun|proper_noun] plural_noun|plural_proper_noun "are"
  match = tagged.match(/\b(?:(\w+)\/(JJ|NNP?)\s+)?(\w+)\/(NNP?S)\s+(?i:are)\b/)
  
  next if !match
  
  before = match.pre_match
  
  # Skip tweets with possessives
  next if before.match(/\b(?:me|my|us)\/\w+\s+$/i)
  next if before.match(/\/(?:POS|PRPS?)\s+$/)
  
  # Skip tweets referring to a specific instance of a class of things
  next if before.match(/\/DET\s+$/)
  
  # Skip tweets discussing a specific cardinal number of things
  next if before.match(/\/CD\s+$/)
  
  adjective = (match[1] or "")
  adjective_pos = (match[2] or "")
  noun = match[3]
  noun_pos = match[4]
  
  # Downcase our 'adjective' and 'noun' unless they are proper nouns
  adjective = adjective.downcase unless adjective_pos.match(/NNPS?/)
  noun = noun.downcase unless noun_pos.match(/NNPS?/)
  
  # Skip things that tend to get mistagged as plural nouns
  next if noun.match(/^yours$/i)
  
  # Skip tweets with possessives
  # ("my" gets mistagged as a proper noun sometimes.)
  next if adjective.match(/^my$/i)
  
  # Don't be boring
  next if noun.match(/^(?:men|guys)$/i)
  
  puts line
  puts " -> @#{screen_name} Not all #{adjective} #{noun}!"
  puts
end
