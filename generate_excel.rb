require 'rubygems'
require 'spreadsheet'
load 'Question.rb'

Spreadsheet.client_encoding = 'UTF-8'

# Generate excel file based on category and tags
def generateExcelFromArray(questions_array, category, tags,file_num)
  book = Spreadsheet::Workbook.new
  sheet1 = book.create_worksheet
  sheet1.row(0).concat %w{QuestionNo TestName Category Tags Directions QuestionText QuestionImage AnswerText AnswerImage Correct Option Option Option Option}
  row_num = 1

  questions_array.each do |question|
    row = sheet1.row(row_num)
    row[0] = row_num
    row[1] = question.test_name
    row[2] = question.category
    row[3] = question.tags.join(",")
    row[4] = question.directions
    row[5] = question.question_text
    row[6] = question.question_image
    row[7] = question.answer_text
    row[8] = question.answer_image
    row[9] = question.correct_answer
    row[10] = question.options[0]
    row[11] = question.options[1]
    row[12] = question.options[2]
    row[13] = question.options[3]


    row_num = row_num + 1
  end
  #Formatting row
  sheet1.row(0).height = 18
  format = Spreadsheet::Format.new :color => :blue,:weight => :bold,:size => 12
  sheet1.row(0).default_format = format
  book.write "/home/malav/rails_projects/generated_excels/#{category}-#{tags}-#{file_num}.xls"
end

def getSortedArrayFromString(str)
  arr = (str == nil ? [] : (str.split(',').map!(&:strip)))
  arr.sort!
  return arr
end


# Build a new instance of Question class and populate
# data from the row.
def getQuestionFromRow(row)
  question = Question.new

  if row[0].class == Spreadsheet::Formula
    question.question_no = row[0].value.to_i
  else
    question.question_no = row[0].to_i
  end

  question.test_name = row[1]
  question.category = row[2]
  question.tags = getSortedArrayFromString(row[3])
  question.directions = row[4]
  question.question_text = row[5]
  question.question_image = row[6]
  question.answer_text = row[7]
  question.answer_image = row[8]
  question.correct_answer = row[9]
  question.options.push(row[10], row[11], row[12], row[13])
  return question
end

# Reading excel file which has data
book = Spreadsheet.open 'Questions-1.xls'
sheet = book.worksheet 0
questions = []
category_questions_hash = {}

sheet.each_with_index do |row,index|
  next if index == 0
  questions.push getQuestionFromRow(row)
end

# Populate each and every questions from questions array
questions.each do |question|

  tags_string = question.tags.join(",")
  category_string = question.category
  
  if category_questions_hash[category_string] == nil
    category_questions_hash[category_string] = {}
  end

  # Create nested hash which has category as a key and tags as a value
  # and this tags is also a key and it has questions as a value stored in array
  if category_questions_hash[category_string][tags_string] == nil
    category_questions_hash[category_string][tags_string] = []
  end
  
  category_questions_hash[category_string][tags_string].push question
end

category_questions_hash.each do |category,tags_string_hash|
  tags_string_hash.each do |tag_string,questions|
    
    # Divide array into group so exact that number of questions generate one excel file
    array_of_questions_array = questions.each_slice(20).to_a
    file_num = 0
    array_of_questions_array.each do |questions_array|
      file_num = file_num + 1

      generateExcelFromArray(questions_array,category,tag_string,file_num)

    end
  end
end

#puts category_questions_hash.keys