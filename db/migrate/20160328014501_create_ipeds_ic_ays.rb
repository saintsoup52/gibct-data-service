class CreateIpedsIcAys < ActiveRecord::Migration
  def change
    create_table :ipeds_ic_ays do |t|
      t.string :cross, null: false
      t.integer :tuition_in_state, default: nil
      t.integer :tuition_out_of_state, default: nil
      t.integer :books, default: nil

      t.timestamps null: false

      t.index :cross
    end
  end
end
