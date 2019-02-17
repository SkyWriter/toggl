class CreateApiKeyField < Rails.version < '5.1' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]

  def up
    custom_field = CustomField.new_subclass_instance('UserCustomField', {
      :name => 'Toggl API Key',
      :field_format => 'string',
      :min_length => 32,
      :max_length => 32,
      :regexp => '',
      :default_value => '',
      :is_required => 0,
      :visible => 1,
      :editable => 1,
      :is_filter => 0
    })
    custom_field.save!
  end
  
  def down
    CustomField.find_by_name('Toggl API Key').destroy
  end

end
