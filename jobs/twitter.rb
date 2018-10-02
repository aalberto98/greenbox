require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = '8KjhXIhmRD781R2MmLjBnDZ8s'
  config.consumer_secret = '6Kb96BdIhDfElE81KT42xMGeX3SZxMXGEXjrXBbrPOh8FwxZDv'
  config.access_token = '22433942-QfcMhYdUmpBpZwpStM7KMHklI4jQtLoNnG3v4N6Fq'
  config.access_token_secret = 'KWUBxJCsp9uluEOfsOtwvsJod9sknNzb3m6hVAeuRiKlL'
end

SCHEDULER.every '1m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("parque roma")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
