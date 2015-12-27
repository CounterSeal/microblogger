require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
	end

	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ''
		while command != 'q'
			printf "Enter command: "
			input = gets.chomp
			parts = input.split(' ')
			command = parts[0]

			case command
			when 'q' then puts "Goodbye!"
			when 't' then tweet(parts[1..-1].join(' '))
			when 'dm' then dm(parts[1], parts[2..-1].join(' '))
			when 'spam' then spam_my_followers(parts[1..-1].join(' '))
			else
				puts "Sorry, I don't know how to #{command}"
			end
		end
	end

	def tweet(message)
		error = "Tweets must be 140 characters or less."
		if message.length <= 140
			@client.update(message)
			puts "Tweet posted!"
		else
			puts error
		end
	end

	def dm(target, message)
		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
		puts "Trying to send #{target} this direct message:"
		puts message

		if screen_names.include?(target)
			message = "d @#{target} #{message}"
			tweet(message)
		else
			puts "Sorry, you can only directly message people who follow you."
		end
	end

	def spam_my_followers(message)
		followers = followers_list
		followers.each { |follower| dm(follower, message) }
	end

	def followers_list
		screen_names = []
		@client.followers.each { |follower| screen_names << @client.user(follower).screen_name }
		screen_names
	end
end

blogger = MicroBlogger.new
blogger.run
