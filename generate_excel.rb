require 'rubygems'
require 'spreadsheet'
load 'Question.rb'

Spreadsheet.client_encoding = 'UTF-8'

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
  question.tags = row[3]
  question.directions = row[4]
  question.question_text = row[5]
  question.question_image = row[6]
  question.answer_text = row[7]
  question.answer_image = row[8]
  question.correct_answer = row[9]
  question.options.push(row[10], row[11], row[12], row[13])
  return question
end

book = Spreadsheet.open 'Questions-1.xls'
puts book
sheet = book.worksheet 0
puts sheet
questions = []

sheet.each_with_index do |row,index|
  next if index == 0
  questions.push getQuestionFromRow(row)
end

puts questions[1].category

questions.each do |question|
    question.print   
end



