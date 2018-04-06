# Holds all the information that we gather from Toggl
class TogglAPIEntry < Struct.new(:id, :issue_id, :started_at, :duration, :description, :activity_name)
end
