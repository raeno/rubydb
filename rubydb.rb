require 'sinatra'

class RubyDB
	attr_accessor :tables

	def initialize
		@tables = {}
	end

	def create_table(name)
		@tables[name] = Table.new
	end

	def drop_table(name)
		@tables.delete name
	end
end

class Table

	attr_reader :rows

	def initialize
		@rows = {}
	end

	def create(key, value)
		return false if @rows.include? key
		@rows[key] = value
	end

	def update(key, new_value)
		@rows[key] = new_value
	end

	def read(key)
		@rows[key]
	end

	def delete(key)
		@rows.delete key
	end

	def rows_count
		@rows_count = @rows.count
	end
end

instance = RubyDB.new

get '/' do
  'Welcome to RubyDB web interface'
end

get '/create/:table_name' do
	instance.create_table params[:table_name]
end

get '/drop/:table_name' do
	instance.drop_table params[:table_name]
end

get '/:table_name' do
	table_name = params[:table]
	if instance.tables.include? table_name
		table = instance.tables[table_name]
		table.rows.take(10).each { |row| puts row }
	else
		"There are no table with name #{table_name}"
	end
end

get '/:table/create/:key=:value' do
	table_name = params[:table]
	if instance.tables.include? table_name
		table = instance.tables[table_name]
		table.create params[:key],params[:value]
	else
		"There are no table with name #{table_name}"
	end
end

get '/:table/update/:key=:value' do
	table_name = params[:table]
	if instance.tables.include? table_name
		table = instance.tables[table_name]
		table.update params[:key],params[:value]
	else
		"There are no table with name #{table_name}"
	end
end

get '/:table/delete/:key' do
	table_name = params[:table]
	if instance.tables.include? table_name
		table = instance.tables[table_name]
		table.delete params[:key]
		redirect "/#{table_name}" 
	else
		"There are no table with name #{table_name}"
	end
end

