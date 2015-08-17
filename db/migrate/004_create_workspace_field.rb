class CreateWorkspaceField < ActiveRecord::Migration

  def up
    custom_field = CustomField.new_subclass_instance('UserCustomField', {
      :name => 'Toggl Workspace',
      :field_format => 'string',
      :min_length => 0,
      :max_length => 255,
      :regexp => '',
      :default_value => '',
      :is_required => false,
      :visible => false,
      :editable => true,
      :is_filter => false
    })

    custom_field.save!
  end

  def down
    CustomField.find_by_name('Toggl Workspace').destroy
  end

end
