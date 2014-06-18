#!/usr/bin/env ruby

require 'twitter_ebooks'
require 'parseconfig'

config = ParseConfig.new('bots.conf')

Ebooks::Bot.new("NotAllBot") do |bot|
  bot.consumer_key = config["NotAllBot"]["consumer_key"]
  bot.consumer_secret = config["NotAllBot"]["consumer_secret"]
  bot.oauth_token = config["NotAllBot"]["oauth_token"]
  bot.oauth_token_secret = config["NotAllBot"]["oauth_token_secret"]

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
