#!/usr/bin/env ruby

require 'twitter_ebooks'

# This is an example bot definition with event handlers commented out
# You can define as many of these as you like; they will run simultaneously

Ebooks::Bot.new("NotAllBot") do |bot|
  # Consumer details come from registering an app at https://dev.twitter.com/
  # OAuth details can be fetched with https://github.com/marcel/twurl
  bot.consumer_key = "fj70XPBauY4ih7gxNVBK0jpM8" # Your app consumer key
  bot.consumer_secret = "kxKZSI88EKtE5tXTu0LUrd8N5f7tJDzu7PBIx0BTGj8ufWEDDF" # Your app consumer secret
  bot.oauth_token = "2405128038-YO3HYh7M6Z8jCd4SPdHx4JMmWwFwJzh8YIJWyu7" # Token connecting the app to this account
  bot.oauth_token_secret = "bb2mAfIDys5diIy7WQOVh9WGObZNFucytcRwHYnTuRh0m" # Secret connecting the app to this account

  bot.on_startup do |dm|
    bot.stream.track('are') do |status|
      #return if status.retweeted_status
      #return if status.text.match /^[MR]T\b/
      #return if status.text.match /\bnot\s+all\b/i
      #return if status.text.match /y.all/i
      #
      #match = status.text.match /\ball\s+(\w+)\s+(\w+)/i
      #
      #a, b = match[1], match[2]
      #
      #return if !(a&&b)
      #
      screen_name = status.user.screen_name
      text = status.text.gsub(/\s/," ")
      
      puts "#{screen_name}: #{text}"
    end
    
    bot.stream.on_error do |message|
      puts "ERROR: ${message}"
    end
    
    bot.stream.on_limit do |skip_count|
      puts "limit: #{skip_count}"
    end

    bot.stream.on_enhance_your_calm do
      puts "ENHANCE YOUR CALM"
    end
  end

  bot.on_message do |dm|
    # Reply to a DM
    # bot.reply(dm, "secret secrets")
  end

  bot.on_follow do |user|
    # Follow a user back
    # bot.follow(user[:screen_name])
  end

  bot.on_mention do |tweet, meta|
    # Reply to a mention
    # bot.reply(tweet, meta[:reply_prefix] + "oh hullo")
  end

  bot.on_timeline do |tweet, meta|
    # Reply to a tweet in the bot's timeline
    # bot.reply(tweet, meta[:reply_prefix] + "nice tweet")
  end

  bot.scheduler.every '24h' do
    # Tweet something every 24 hours
    # See https://github.com/jmettraux/rufus-scheduler
    # bot.tweet("hi")
  end
end
