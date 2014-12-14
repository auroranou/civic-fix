class CreatePosts < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.string :title, null: false
  		t.text :description, null: false
  		t.references :users

  		t.timestamps
  	end
  end
end
