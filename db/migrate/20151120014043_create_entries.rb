class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :entry_id
      t.date :date
      t.decimal :hours
      t.string :project
      t.string :task
      t.string :consultant

      t.timestamps null: false
    end
  end
end
