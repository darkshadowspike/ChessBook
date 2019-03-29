require 'rails_helper'

RSpec.shared_examples "user_attributes" do | user_attr|

	let(:user) {user = User.new(first_name: "andrew", last_name: "matos", user_name: "andrewmatos", email: "andrewmatosdiaz@gmail.com", birthday: Date.new(1997,5,28), gender: "male" ,password: "andrewb117" , password_confirmation: "andrewb117")}
	
	it "its not valid with an empty  first name" do 
	   	user[user_attr]= nil
	   	expect(user.valid?).to eq(false)
	end

	it "its not valid with an empty string" do 
	  	user[user_attr] =" " * 6
	   expect(user.valid?).to eq(false)
	end

	it "its not valid if is longer than 20 characters" do 
	   	user[user_attr] = "Wolfeschlegelsteinhausenbergerdorff"
	   	expect(user.valid?).to eq(false)
	end

end

RSpec.describe User, type: :model do
	let(:user) {user = User.new(first_name: "andrew", last_name: "matos", user_name: "andrewmatos", email: "andrewmatosdiaz@gmail.com", birthday: Date.new(1997,5,28), gender: "male" ,password: "andrewb117" , password_confirmation: "andrewb117")}

   describe "validations" do 

   		it "should be valid" do   
   			expect(user.valid?).to eq(true)
   			
   		end

   	 
   	 	context "when validates first_name" do
	   	 	it_behaves_like "user_attributes",  "first_name"

	   	 	it "its not valid if it contain numbers" do 
	   	 		user.first_name= "123"
	   	 		expect(user.valid?).to eq(false)
	   	 	end

   	    end

   	    context "when validates first_name" do

	   	 	it_behaves_like "user_attributes",  "last_name"

	   	 	it "its not valid if it contain numbers" do 
	   	 		user.last_name= "123"
	   	 		expect(user.valid?).to eq(false)
	   	 	end

   	    end

   	    context "when validates user_name" do

            it "its not valid with an empty string" do 
                user["user_name"] =" " * 6
                expect(user.valid?).to eq(false)
            end

             it "its not valid if is longer than 20 characters" do 
               user["user_name"] = "Wolfeschlegelsteinhausenbergerdorff"
               expect(user.valid?).to eq(false)
             end
   	    end

   	    context "when validates email" do

   	    	it "shoudln't accept nill" do 
   	    		user.email = nil
   	    		expect(user.valid?).to eq(false)
   	    	end


	   	 	it "validates the correct format " do 
	   	 		valid_addresses = ["user.@example.com", "USER@foo.COM", "A_US-ER@foo.bar.org", "first.last@foo.jp", "alice+bob@baz.cn"]
	   	 		validation = true
	   	 		valid_addresses.each do |addres| 
	   	 			user.email = addres
	   	 			unless user.valid? 
	   	 				validation = false
	   	 			end
	   	 		end
	   	 		expect(validation).to eq(true)
	   	 	end

	   	 	it "rejects the incorrect format " do 
	   	 		invalid_addresses = ["user@example,com", "user_at_foo.org", "user.name@example.", "foo@bar_baz.com", "foo@bar+baz.com", "foo@bar..com"]
	   	 		validation = true
	   	 		invalid_addresses.each do |addres| 
	   	 			user.email = addres
	   	 			unless user.valid? 
	   	 				validation = false
	   	 			end
	   	 		end
	   	 		expect(validation).to eq(false)
	   	 	end

	   	 	it "should be unique" do 
	   	 		duplicate_user= user.dup
	   	 		duplicate_user.email = user.email
	   	 		user.save
	   	 		expect(duplicate_user.valid?).to eq(false)
	   	 	end

   	    end

   	    context "when validates gender" do 
   	    		it_behaves_like "user_attributes",  "gender"

   	    		it "should be either male or female " do
   	    		user.gender = "crab" 
   	    		expect(user.valid?).to eq(false)
   	    		end
   	    end 

   	    context "when validates date" do 

   	    	it "shoudln't accept nill" do 
   	    		user.birthday = nil
   	    		expect(user.valid?).to eq(false)
   	    	end

   	    	it "should be a date" do 
   	    		expect(user.birthday.class).to eq(Date)
   	    	end

   	    	it "should be a posible date" do 
   	    		user.birthday = Date.new(1899,5,28)
   	    		expect(user.valid?).to eq(false)
   	    	end

   	    end 

   	    context "when validates password" do 


   	    	it "shouldn't accept nill" do 
   	    		user = User.new( first_name: "andrew", last_name: "matos", user_name: "andrewmatos", email: "andrewmatosdiaz@gmail.com", birthday: Date.new(1997,5,28), gender: "male", password: nil, password_confirmation: nil)
   	    		expect(user.valid?).to eq(false)
   	    	end
   	    	

   	    	it "should have a minimum length" do 
   	    		user = User.new(first_name: "andrew", last_name: "matos", user_name: "andrewmatos", email: "andrewmatosdiaz@gmail.com", birthday: Date.new(1997,5,28), gender: "male", password: "aaaa", password_confirmation: "aaaa")
   	    		expect(user.valid?).to eq(false)
   	    	end

   	    	it "should have a maximum length" do 
   	    		user = User.new(first_name: "andrew", last_name: "matos", user_name: "andrewmatos", email: "andrewmatosdiaz@gmail.com", birthday: Date.new(1997,5,28), gender: "male", password: "a"*50, password_confirmation: "a"*50)
   	    		expect(user.valid?).to eq(false)
   	    	end

   	    	it "shouldn't validate differents password and password confirmation " do 
   	    		user = User.new(first_name: "andrew", last_name: "matos", user_name: "andrewmatos", email: "andrewmatosdiaz@gmail.com", birthday: Date.new(1997,5,28), gender: "male", password: "andrewb117", password_confirmation: "andrewb118")
   	    		expect(user.valid?).to eq(false)
   	    	end
   	    end

   	    

   end

end
