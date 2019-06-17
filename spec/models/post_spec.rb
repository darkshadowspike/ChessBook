require 'rails_helper'

RSpec.describe Post, type: :model do
	let(:user) {user = User.create(first_name: "andrew", last_name: "matos", user_name: "andrewmatos", email: "andrewmatosdiaz@gmail.com", birthday: Date.new(1997,5,28), gender: "male" ,password: "andrewb117" , password_confirmation: "andrewb117")}
  	let(:post) {user.posts.build(content: "Animal man is dc best hero")}

  	it "should be valid" do 
  		expect(post.valid?).to eq(true)

  	end

    context "when validates user id" do
    	it "shouldn't accept nil" do 
    		post.user_id = nil
    		expect(post.valid?).to eq(false)
    	end
    end

    context "when validates content" do
    	it "shouldn't accept nil" do 
    		post.content = nil
    		expect(post.valid?).to eq(false)
    	end

    	it "should have max 130 characters" do 
    		post.content = "s"* 131
    		expect(post.valid?).to eq(false)
    	end

    	it "shouldn't accept empty strings" do 
    		post.content = "      "
    		expect(post.valid?).to eq(false)
    	end
    end

    context "when validates media uploaded" do  

        it "should accept valid media" do 
            post.media.attach(io: File.open('spec/models/Files/image.jpg'), filename: "image.jpg")
            expect(post.valid?).to eq(true)
        end 
        
        it "shouldn't accept invalid media" do 
            post.media.attach(io: File.open('spec/models/Files/invalid.pdf'), filename: "invalid.pdf")
            expect(post.valid?).to eq(false)
        end 
        
    end

end
