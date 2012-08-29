require 'spec_helper'

describe Bud do
  before do
		@bud = Bud.new(name: "bud 1", uid: "130", hardware_v: "1.0", firmware_v: "1.0") 
	end

	subject { @bud }

	it { should respond_to(:name) }
	it { should respond_to(:uid) }
	it { should respond_to(:hardware_v) }
	it { should respond_to(:firmware_v) }

	it { should be_valid }

	describe "when uid is not present" do
		before { @bud.uid = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
    	before { @bud.name = "a" * 51 }
    	it { should_not be_valid }
  	end

	describe "when bud is already taken for that uid" do
		before do
			bud_with_same_uid = @bud.dup
			bud_with_same_uid.save
		end

		it { should_not be_valid }
	end
end
