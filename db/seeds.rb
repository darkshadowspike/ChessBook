# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Post.destroy_all

admin = User.create!(first_name:"admin", last_name:"istrator", user_name: "administrator" ,email: "andrewmatosdiaz@hotmail.com", gender: "male", birthday: Date.today, password: "adminb117", password_confirmation: "adminb117", activated: true , activated_at: Time.zone.now, admin: true)
admin.avatar.attach(io: File.open('./public/default_profile_pic.png'), filename: "default_profile_pic.png")
admin.mural.attach(io: File.open('./public/default_profile_mural.jpg'), filename: "default_profile_mural.jpg")

20.times do |index| 
	user = User.create!(
		first_name: "seeded",
		last_name: "user",
		user_name: "seeded user #{index}",
		email: "seeduser#{index}@mail.com",
		gender: "male",
		birthday: Date.today,
		password: "Password",
		password_confirmation: "Password",
		activated: true,
		activated_at: Time.zone.now
	)
	user.avatar.attach(io: File.open('./public/default_profile_pic.png'), filename: "default_profile_pic.png")
	user.mural.attach(io: File.open('./public/default_profile_mural.jpg'), filename: "default_profile_mural.jpg")
end

user =  User.find_by(email: "seeduser1@mail.com" )

10.times do |index|
	post_img = user.posts.create!(content: "Servants chess #{index}" )
	post_img.media.attach(io: File.open('/servantchess.jpg'), filename: "servantchess.jpg")
	user.posts.create!(content: "hello there! #{index}")
end