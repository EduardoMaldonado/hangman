class Play
	attr_accessor :random_word
		
	def initialize
		@random_number=rand(61406) #Generate a random number
		@random_word=File.readlines("5desk.txt")[@random_number].chomp.to_s.upcase #read the random number generated line
		@correct_position=@random_word.split(//) #split the word in individual letters
		@correct_guesses=Array.new #Create the list of the correct answers
		@incorrect_guesses=Array.new #Create the list of the incorrect answers
		@random_word.length.times {@correct_guesses<<"_ "} #It puts one underscore in guess array for each letter in word
		puts "The secret word is..\n"
		@correct_guesses.each_with_index { |value, index| print @correct_guesses[index]} #draw underscores. one for each letter
		puts "\n\n"
		puts "#{@correct_position}"
	end

	def draw
		@correct_guesses.each_with_index { |value, index| print @correct_guesses[index]} #Current state of guessed correctly letters
		puts "\n\nLetters not in secret word: "
		@incorrect_guesses.each_with_index { |value, index| print @incorrect_guesses[index] + ", "} #letters guessed not in the word
	end

	def turn
		puts "Select a letter" #Ask for letter
		try=gets.chomp.to_s.upcase #Reads the letter
		check_correct(try) #Check if correct
	end

	def check_correct(try)
		guessed_right=false
		@correct_position.each_with_index do |value, index| #matches each letter with the guess attemp
			if try==value	
				@correct_guesses[index]=try #if they are equal, deletes underscore and puts the correct letter
				guessed_right=true
			end
		end

		if guessed_right==false #if no letter was equal
				if @incorrect_guesses.include?(try)==false #put the letter to the incorrect guesses array
					@incorrect_guesses<<try 
				end
		end
	end

	def check_win
		if @correct_guesses==@correct_position #it is a win if the guessed array is equal to the letters array
			return true
		else
			return false
		end
	end

end

class Game	#Controls game logic
	def start_new_game
		@board=Play.new
		turn_counter=0
		loop do
			if turn_counter<20
			@board.turn
			turn_counter+=1
			@board.draw
			puts "You have #{20-turn_counter} turns left"
				if @board.check_win==true
					puts "\nCongrtulations, you win!"
					break
				end
			else
				puts "You ran out of attemps!, You lose!"
				puts "The secret word was #{@board.random_word}"
				break
			end
		end
	end
end

Game.new.start_new_game