class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.string :email
      t.date :birthday
      t.string :gender
      t.string :password_hash

      t.timestamps
    end
  end
end
