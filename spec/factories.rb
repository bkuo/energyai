FactoryGirl.define do
	factory :user do
		sequence(:name)  { |n| "Person #{n}" }
		sequence(:email) { |n| "Person_#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"

		factory :admin do
			admin true
		end
	end		

	factory :microalert do
		#content = Faker::Lorem.sentence(5) doesn't work in rspec environment
		sequence(:content) { |n| "Lorem Ipsum #{n}" }
		user
	end
	
end