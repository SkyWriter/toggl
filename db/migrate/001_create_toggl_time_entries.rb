class CreateTogglTimeEntries < ActiveRecord::Migration
  def change
    create_table :toggl_time_entries do |t|
      t.column :id, :integer
    end

    add_index :toggl_time_entries, [:id], :name => "id"
  end
end
