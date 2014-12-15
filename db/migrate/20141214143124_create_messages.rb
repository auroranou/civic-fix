class CreateMessages < ActiveRecord::Migration
  def change
  	create_table :messages do |t|
  		t.string :mail_to, null: false
  		t.string :mail_from, null: false
  		t.string :subject, null: false
  		t.text :body, null: false
  		t.references :users

  		t.timestamps
  	end
  end
end
