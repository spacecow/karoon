class CreateSignupTokens < ActiveRecord::Migration
  def change
    create_table :signup_tokens do |t|
      t.integer :user_id
      t.string :token
      t.string :email

      t.timestamps
    end
  end
end
