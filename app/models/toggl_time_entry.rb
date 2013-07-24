class TogglTimeEntry < ActiveRecord::Base
  unloadable
  
  def self.with_ids(ids)
    where('id IN (?)', [*ids])
  end
  
  def self.register_synced_entry(id)
    entry = new
    entry.id = id
    entry.save
  end
end
