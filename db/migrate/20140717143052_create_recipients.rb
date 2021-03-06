class CreateRecipients < ActiveRecord::Migration
  def change
    create_table :recipients do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email_address
      t.text :email_template

      t.timestamps
    end
  end
end
