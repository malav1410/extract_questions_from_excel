class Question
	attr_accessor :question_no, :options, :test_name, :category, :directions, :question_text, :question_image, :answer_text, :answer_image, :correct_answer, :tags
	def initialize
		@options = []
	end	
	def print
		puts "#" + question_no.to_s + "\n"
		puts "Category :" + category
		puts "Tags :" + (tags == nil ? "nil" : tags )
		puts "Question :" + question_text
		puts "Options :" + "\n"
		puts "A" + (correct_answer == 1 ? "*" : "" ) + ":" + options[0].to_s
		puts "B" + (correct_answer == 2 ? "*" : "" ) + ":" + options[1].to_s
		puts "C" + (correct_answer == 3 ? "*" : "" ) + ":" + options[2].to_s
		puts "D" + (correct_answer == 4 ? "*" : "" ) + ":" + options[3].to_s
		puts "\n\n"
	end
end


#q = Question.new

#q.question_no = 5
#q.options.push(123)

#puts q.question_no.inspect
#puts q.options


    
     
     
     
     
     
    