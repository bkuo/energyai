# == Schema Information
#
# Table name: circuits
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bud_id     :integer
#  location   :float
#  side       :integer
#

require 'spec_helper'

describe Circuit do
	let(:bud) { FactoryGirl.create(:bud) }
    let(:circuit) { FactoryGirl.create(:circuit, bud: bud) }

	subject { circuit }
	it { should respond_to(:name) }
    it { should respond_to(:channel) }
    it { should respond_to(:circuit_type_id) }
    it { should respond_to(:status) }
    it { should respond_to(:ip) }
    it { should respond_to(:bud_id) }
    it { should respond_to(:bud) }
    its(:bud) { should == bud }
	it { should be_valid }

	describe "accessible attributes" do
    	it "should not allow access to bud_id" do
      		expect do
        		Circuit.new(bud_id: bud.id)
      		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    	end    
  	end

	describe "when bud_id is not present" do
    	before { circuit.bud_id = nil }
    	it { should_not be_valid }
  	end

    describe "when channel is not present" do
        before { circuit.channel = nil }
        it { should_not be_valid }
    end
end
