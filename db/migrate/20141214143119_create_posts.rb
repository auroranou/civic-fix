class CreatePosts < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.string :title, null: false
  		t.text :description, null: false
  		t.references :user

  		t.timestamps
  	end
  end
end
