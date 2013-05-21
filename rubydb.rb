require 'sinatra'
require 'json'

class RubyDB

	def initialize
		@tables = {}
		if File.exist? './ruby.db'
			load_from_file './ruby.db'
		end
	end

	def load_from_file(filename)
		tables_hash = JSON.parse File.read(filename)
		tables_hash.each do |table_name, table_rows|
			table = create_table table_name
			table_rows.each do |key, value|
				table.create key,value
			end
		end
	end

	def create_table(name)
		@tables[name] = Table.new
	end

	def drop_table(name)
		@tables.delete name
	end

	def table_names
		@tables.keys
	end

	def get_table(name)
		@tables[name]
	end

	def commit
		File.open('./ruby.db', 'w') { |f| f.write @tables.to_json }
	end
end

class Table
	attr_reader :changed
	attr_reader :rows

	def initialize
		@rows = {}
		@changed = false
	end

	def create(key, value)
		return false if @rows.include? key
		@rows[key] = value
		@changed = true
	end

	def update(key, new_value)
		@rows[key] = new_value
		@changed = true
	end

	def read(key)
		@rows[key]
	end

	def delete(key)
		@rows.delete key
		@changed = true
	end

	def rows_count
		@rows_count = @rows.count
	end

	def to_json(*a)
		@json = nil if @changed
		@json ||= @rows.to_json(*a)
	end
end

configure do
	set :database, RubyDB.new	
end


def prepare_table
	@table = settings.database.get_table params[:table]
	raise 'No such table' unless @table
end

get '/' do
	message = "Welcome to RubyDB web interface.<br> There are such tables in database:<br><br> <ul>"

	settings.database.table_names.each do |table|
		message += "<li> #{table} </li>"
	end
	message += '</ul>'
	[200,message]
end

get '/commit' do
	settings.database.commit
end

get '/create/:table' do
	settings.database.create_table params[:table]
	[200, "Table #{params[:table]} added to database"]
end

get '/drop/:table' do
	settings.database.drop_table params[:table]
	[200, "Table #{params[:table]} removed from database"]
end

get '/:table' do
	prepare_table
	rows_to_print =[]
	@table.rows.take(10).each { |row| rows_to_print << row.to_s }
	[200, rows_to_print.to_s]
end

get '/:table/:key' do
	prepare_table
	value = @table[params[:key]]
	raise 'No such key in db' unless value
	[200, value.to_s]
end

get '/:table/create/:key=:value' do
	prepare_table
	@table.create params[:key],params[:value]
end

get '/:table/update/:key=:value' do
	prepare_table
	@table.update params[:key],params[:value]
end

get '/:table/delete/:key' do
	prepare_table
	@table.delete params[:key]
	redirect "/#{params[:table]}" 
end

