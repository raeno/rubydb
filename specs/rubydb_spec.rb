require 'rspec'
require './rubydb'

describe RubyDB do

	subject { RubyDB.new }

	it { should respond_to :tables }

	specify 'fresh DB should contain no tables' do
		subject.tables.should be_empty
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

			}.should change(subject, :rows_count).by(1)
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
					table.delete '2'
					table.delete '3'
				end
				it 'returns 1 as rows_count' do
					table.rows_count.should == 1
				end
			end
		end
	end

end

describe Row do
	subject { Row.new('key', 'NotSoBigValue') }

	it { should respond_to :key }
	it { should respond_to :value }
	it { should respond_to :live }

	it 'live by default' do
		subject.live.should be_true
	end
end