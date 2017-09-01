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

	#NOTE: API DOCS: https://canvas.instructure.com/doc/api
	#TODO: Figure out how to generate pairs where you don't work with the same person 2 times
	#TODO: When the script generates the groups use the canvas API to generate the groups with the pairs

	# API CODE TO CREATE A GROUP
	# c = Curl::Easy.http_post(CANVAS_BASE_URL + "/courses/42/group_categories",
  #                        Curl::PostField.content('name', 'test api group')) do |http|
	# 												  http.headers['Authorization'] = "Bearer #{ACCESS_TOKEN}"
	# 											 end
	# ASSIGN MEMBERS API END POINT
	# https://canvas.instructure.com/doc/api/group_categories.html#method.group_categories.assign_unassigned_members

	def initialize
		puts 'What is the course Id?'
		@course_id = gets.to_i
		@pairs = []
		@picked = []
		generate_pairs(course_id)
		@pairs.each_with_index do |pair, index|
			puts "Pair: #{index + 1} - #{pair.join(',')}"
		end
	end

	def pick_students(students)
		@pairs = students.each_slice(2).to_a
	end

	def generate_pairs(course_id)
		http = Curl.get(CANVAS_BASE_URL + "/courses/#{course_id}/students") do |http|
		  http.headers['Authorization'] = "Bearer #{ACCESS_TOKEN}"
		end
	  pick_students(JSON.parse(http.body_str).map{|student| student['name']}.shuffle)
	end
end

PairMaker.new
