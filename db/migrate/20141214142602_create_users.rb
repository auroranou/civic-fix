class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :name
  		t.string :email, null: false
  		t.string :password, null: false
  		# t.string :password_confirmation, null: false
  		t.integer :zipcode

  		t.timestamps
  	end
  end
end
