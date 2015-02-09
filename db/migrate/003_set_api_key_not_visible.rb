class SetApiKeyNotVisible < ActiveRecord::Migration

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

