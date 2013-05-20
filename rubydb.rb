require 'sinatra'

class RubyDB
	attr_accessor :tables

	def initialize
		@tables = []
	end
end

class Table

	def initialize
		@rows = []
	end

	def create(key, value)
		@rows << Row.new(key,value)
		@rows_count = nil
	end

	def update(key, new_value)
		@rows.first { |row| row.key == key }
	end

	def read(key)
	end

	def delete(key)
		@rows_count = nil
		@rows.first { |row| row.key == key}.live = false
	end

	def rows_count
		@rows_count = @rows.select(&:live).count
	end

end

class Row
	attr_accessor :key, :value, :live

	def initialize(key, value)
		self.key = key
		self.value = value
		self.live = true
	end
end

get '/' do
  'Hello world!'
end