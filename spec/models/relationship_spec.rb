require 'rails_helper'

RSpec.describe Relationship, type: :model do
  
  let(:user) {user = User.create(first_name: "andrew", last_name: "matos", user_name: "andrewmatos", email: "andrewmatosdiaz@gmail.com", birthday: Date.new(1997,5,28), gender: "male" ,password: "andrewb117" , password_confirmation: "andrewb117")}
  let(:user2) {user2 = User.create(first_name: "andrew", last_name: "lopez", user_name: "andrewlopez", email: "2andrewmatosdiaz@gmail.com", birthday: Date.new(1997,5,28), gender: "male" ,password: "andrewb117" , password_confirmation: "andrewb117")}
  let(:relationship) {relationship = Relationship.new(friend_active_id: user.id , friend_pasive_id: user2.id)}

  describe "validations" do 
	  it "should be valid" do 
	  	relationship.errors.full_messages
	  	expect(relationship.valid?).to eq(true)
	  end

	  context "validating id" do

	  	it "shouldn't accept nil friend_active_id"do 
	  		relationship.friend_active_id = nil
	  		expect(relationship.valid?).to eq(false)
	  	end

	  	it "shouldn't accept nil friend_pasive_id"do 
	  		relationship.friend_pasive_id = nil
	  		expect(relationship.valid?).to eq(false)
	  	end

	  end
  end
end
