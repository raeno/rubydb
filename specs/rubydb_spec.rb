require './specs/spec_helper'
require './rubydb'

describe RubyDB do

	subject { RubyDB.new }

	it { should respond_to :table_names }
	it { should respond_to :create_table }
	it { should respond_to :drop_table }
	it { should respond_to :commit }

	specify 'fresh DB should contain no tables' do
		subject.table_names.should be_empty
	end
end

describe Table do
	subject { Table.new }

	it { should respond_to :create }
	it { should respond_to :read }
	it { should respond_to :update }
	it { should respond_to :delete }
	it { should respond_to :rows_count }

	describe '#create' do
		it 'adds row to db' do
			expect {
				subject.create '1', 'Test'
			}.to change(subject, :rows_count).by(1)
		end
	end

	describe '#rows_count' do
		let(:table) { Table.new }

		context 'when we have fresh table' do
			subject { Table.new }

			its(:rows_count) { should == 0 }
		end
			
		context "when we add 3 rows to db" do
			before do
				3.times { |n| table.create "#{n}", "test_data_#{n}"}
			end

			it 'returns 3 as rows_count' do
				table.rows_count.should == 3
			end

			context "when we then delete two rows" do
				before do
					table.delete '1'
					table.delete '2'
				end
				it 'returns 1 as rows_count' do
					table.rows_count.should == 1
				end
			end
		end
	end
end