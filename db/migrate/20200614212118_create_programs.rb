class CreatePrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :programs do |t|
      t.string :name
      t.belongs_to :institution, null: false, foreign_key: true

      t.timestamps
    end
  end
end
