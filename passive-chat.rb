require 'twitter'

class PassiveChat

	def initialize(consumer_key, consumer_secret, access_token, access_secret)
		@client = Twitter::REST::Client.new do |config|
			config.consumer_key        = consumer_key
			config.consumer_secret     = consumer_secret
			config.access_token        = access_token
			config.access_token_secret = access_secret
		end	
	end
	
	def run
		loop do
			printf '>'
			msg = gets
			
			if msg.upcase == 'QUIT'
				exit
			else
				@client.search(msg).each do |tweet|
					if tweet.reply?
						begin
							puts @client.status(tweet.in_reply_to_tweet_id).text.to_s.gsub(/\B[@#]\S+\b/, '')
							break
						rescue Twitter::Error::NotFound
							puts 'Whatevs...'
						end
					end
				end
			end
		end
	end

end

chat = PassiveChat.new(
	'CONSUMER_KEY',
	'CONSUMER_SECRET',
	'ACCESS_TOKEN',
	'ACCESS_SECRET'
)

chat.run