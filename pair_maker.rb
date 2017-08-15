require 'pry'
require 'curb'
require 'json'
require 'active_support/all'
require 'dotenv'
Dotenv.load

class PairMaker
	attr_accessor :course_id, :pairs, :picked
	CANVAS_BASE_URL = 'https://canvas.devpointlabs.com/api/v1'
	ACCESS_TOKEN = ENV['CANVAS_API_TOKEN']

	def initialize
		puts 'What is the course Id?'
		@course_id = gets.to_i
		@pairs = []
		@picked = []
		generate_pairs(course_id)
		puts @pairs
	end

	def pick_students(students)
		@pairs << students.each_slice(2).to_a
	end

	def generate_pairs(course_id)
		http = Curl.get(CANVAS_BASE_URL + "/courses/#{course_id}/users?enrollment_type[]=student&per_page=30") do |http|
		  http.headers['Authorization'] = "Bearer #{ACCESS_TOKEN}"
		end
	  pick_students(JSON.parse(http.body_str).map{|student| student['name']}.shuffle)
	end
end

PairMaker.new
