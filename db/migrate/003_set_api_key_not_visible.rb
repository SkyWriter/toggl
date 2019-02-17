class SetApiKeyNotVisible < Rails.version < '5.1' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]

  def up
    custom_field = CustomField.find_by_name('Toggl API Key')
    custom_field.visible = false
    custom_field.save!
  end

  def down
    custom_field = CustomField.find_by_name('Toggl API Key')
    custom_field.visible = true
    custom_field.save!
  end

end

