require 'stuff-classifier'

cls = StuffClassifier::Bayes.new("Success or Failure")
## USAGE:
# cls.train(:success, "message text of the message text")
# cls.classify("message to test")


def getinput(prompt)
	print prompt + "\n> "
	gets().chomp!.downcase
end


########################
########################

def message_to_chunks(msg, db)
	"takes a message that succeeded or failed and sees which chunks it contains"
	includedchunks = []
	for item in db
		idea = item[0]
		ideatext = item[1]

		if msg.include?(ideatext)
			includedchunks << idea
		end
	end

	includedchunks
end

def train_using_chunks(classifier, result, chunkarray)
	"takes a result, an array of chunks (like the output of message_to_chunks) and trains the classifier on it."
	chunkstring = ""
	for chunk in chunkarray
		chunkstring << " #{chunk}"
	end
	# trains on that string (but not the first space)
	puts ("Chunkstring is: ")
	puts chunkstring

	puts("About to train the classifier with: ")
	puts(result.to_sym, chunkstring[1..-1])

	classifier.train(result.to_sym, chunkstring[1..-1])
end

def train_with_message(db, classifier)
	puts "So you want to use a message to train the bayes classifier? Great!"
	
	message = getinput("Paste the message into the prompt below:")
	result = getinput("Is the result of the message Success or Failure?")
	
	chunkedmsg = message_to_chunks(message, db)

	# train the classifier
	if chunkedmsg.empty?
		puts "Warning: Empty Chunkstring || Make sure your message chunks exist in the database before you try to classify it."
	else 
		train_using_chunks(classifier, result, chunkedmsg)
	end
end

########################
########################

def add_new_idea(array)
	"add a new idea string to the array"
	ideatext = getinput("You want to add an idea? Cool.\n\nWhat's the text block associated with this idea?")
	ideakey = getinput("What keyword would you like to associate with this idea? No spaces!")

	if array[ideakey] == nil
		array[ideakey] = ideatext
	else puts "ERROR: You tried to add a keyword that already exists"
	end
end

########################
########################

def evaluate_message(db, classifier)
	"takes the ideaarray and the classifier, returns the result of classification."
	message = getinput("What's the message you want to evaluate?")
	result = classifier.classify(message_to_chunks(message, db))

	puts "The predicted result for your message is:\n\n"
	puts result
end



# keep this hash up to date with any idea-chunks you come up with 
# for your emails
ideaarray = Hash[
	"schnaa", "the idea that represents schnaa",
	"poo", "the idea that represents poo",
	"presidents", "something about obama and bush",
	"professional", "your website will look professional",
	"cheap", "I actually do this stuff pretty cheaply",
	"fast", "making a website is really fast"
]


def mainmenu(ideaarray, classifier)
	input = ""
	while input == ""
		puts "
		Welcome to Dave's Marketing e-mail Classifier!

You can:


(classify) -- CLASSIFY a message that succeeded or failed
(idea) -- add a message-chunk IDEA to the database
(evaluate) -- EVALUATE a message you're thinking of sending
(quit) -- QUIT the application.

"
		
		input = getinput("What do you want to do?")
	end

	if input == "classify"
		train_with_message(ideaarray, classifier)

	elsif input == "idea"
		add_new_idea(ideaarray)

	elsif input == "evaluate"
		evaluate_message(ideaarray, classifier)

	elsif input == "quit"
		puts "Okay, we're exiting now..."
	end
end


########################
###### Main Loop ######
########################

mainmenu(ideaarray, cls)

