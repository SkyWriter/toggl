class CreateTogglTimeEntries < Rails.version < '5.1' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  def change
    create_table :toggl_time_entries do |t|
    end
  end
end
