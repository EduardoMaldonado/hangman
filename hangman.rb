require "yaml"

class Play
	attr_accessor :random_word
		
	def main_menu
		puts "------------------------------------------------------"
		puts "------------------------------------------------------"
			loop do 
			puts "Please select,: (N)ew game, (L)oad, (E)xit"
			choice=gets.chomp.upcase
			case choice
			when "N"
				new_game 
				break
			when "L"
				load
			when "E"
				puts "\nthanks for playing! see you soon!"
				exit		
			else
				puts "\nPlease select 'N' for new game, 'L' to load an existing game, or 'E' to exit"
			end
		end
	end

	def save_game
		directory_name = "saved_games"
		Dir.mkdir(directory_name) unless File.exists?(directory_name)
		puts "\nSelect a name to save your game"
		save_name=gets.chomp
		File.open("saved_games/#{save_name}.yaml","w").puts YAML.dump(self)
		puts "\nGame saved!"
	end

	def load
		display_saved_games
		puts "\nWrite the name of the saved game you want to load"
		load_game=gets.chomp
		if File.exists?("saved_games/#{load_game}.yaml")
			loaded_game=YAML::load(load_game)
			game_loop
		else
			puts "\nNo saved game with that name found, please try again"
			load
		end
	end

	def display_saved_games
		directory_name = "saved_games"
		Dir.mkdir(directory_name) unless File.exists?(directory_name)
		if Dir.glob('saved_games/*').empty?
			puts "No saved games found!"
			main_menu
		else
			puts "Found the following saved games"
			puts Dir.glob('saved_games/*').join("\n")
		end
	end


	def new_game
		@random_number=rand(61406) #Generate a random number
		@random_word=File.readlines("5desk.txt")[@random_number].chomp.to_s.upcase #read the random number generated line
		@correct_position=@random_word.split(//) #split the word in individual letters
		@correct_guesses=Array.new #Create the list of the correct answers
		@incorrect_guesses=Array.new #Create the list of the incorrect answers
		@random_word.length.times {@correct_guesses<<"_ "} #It puts one underscore in guess array for each letter in word
		puts "\nThe secret word is..\n\n"
		@correct_guesses.each_with_index { |value, index| print @correct_guesses[index]} #draw underscores. one for each letter
		puts "\n\n"
		puts "#{@correct_position}"
		game_loop
	end

	def draw
		puts "=============================================================================\n"
		@correct_guesses.each_with_index { |value, index| print @correct_guesses[index]} #Current state of guessed correctly letters
		puts "\n\nLetters not in secret word: "
		@incorrect_guesses.each_with_index { |value, index| print @incorrect_guesses[index] + ", "} #letters guessed not in the word
	end

	def turn
		puts "\nSelect a letter or write 'SAVE' to save your game and continue it later, or 'EXIT' to end the game" #Ask for letter or to save the game
		try=gets.chomp.to_s.upcase #Reads the letter
		if try=="SAVE"
			save_game
		elsif try=="EXIT"
			puts "\n\n\nThanks for playing, see you soon!"
			exit
		else
			check_correct(try) #Check if correct
		end
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
				if @incorrect_guesses.include?(try)==false #put the letter to the incorrect guesses array just if not included before
					@incorrect_guesses<<try 
				else
					guessed_right=true #Avoid the counter to go down if select a repeated letter
					puts "\nYou already said that letter before!"
				end
		end
		return guessed_right
	end

	def check_win
		if @correct_guesses==@correct_position #it is a win if the guessed array is equal to the letters array
			return true
			puts "\n\n\nCongratulations!! you win!"
		else
			return false
		end
	end

	def game_loop #Game logic
		@turn_counter=0
		loop do
			while @turn_counter<10
				if turn==false
					@turn_counter+=1
					puts "You have #{10-@turn_counter} turns left!"
				end
				draw
				if check_win
					break
				end
			end
			puts "\n\n\n\nYou are out of turns, you lose!!!"
			break
		end
	end
end

start=Play.new.main_menu