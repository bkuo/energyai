namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
	    make_users
	    make_microalerts
	    make_user_user_relationships
	    make_buds
        make_circuits
	end
end

def make_users
	admin = User.create!(name: "Luke",
		                 email: "luke@email.com",
		                 password: "foobar",
		                 password_confirmation: "foobar")
    admin.toggle!(:admin)
    35.times do |n|
    	name  = Faker::Name.name
    	email = "example-#{n+1}@railstutorial.org"
    	password = "password"
    	User.create!(name: name,
    				 email: email,
    				 password: password,
	    			 password_confirmation: password)
    end
end

def make_buds
	35.times do |n|
    	name  = Faker::PhoneNumber.phone_number
    	uid = "#{n+1}"
    	hardware_v = "1.0"
    	firmware_v = "1.0"
    	Bud.create!(name: name,
    				 uid: uid,
    				 hardware_v: hardware_v,
	    			 firmware_v: firmware_v)
    end
end

def make_circuits
    buds = Bud.all(limit: 6)
    8.times do |n|
        name  = "#{n/4}.#{n}"
        buds.each { |bud| bud.circuits.create!(name: name)}
    end
end

def make_microalerts
    users = User.all(limit: 6)
    35.times do
    	content = Faker::Lorem.sentence(5)
    	users.each { |user| user.microalerts.create!(content: content)}
    end
end	

def make_user_user_relationships
	users = User.all 
	user = users.first
	followed_users = users[2..50]
	followers      = users[3..40]
	followed_users.each { |followed| user.follow!(followed) }
	followers.each      { |follower| follower.follow!(user) }
end
