Redmine::Plugin.register :toggl do
  name 'Toggl plugin'
  author 'Ivan Kasatenko <sky@uniqsystems.ru>'
  description 'Plugin to support Toggl Redmine integration.'
  version '0.0.4'
  url 'http://github.com/skywriter/toggl'
  author_url 'http://uniqsystems.ru/'
end

Rails.configuration.to_prepare do
  [
    [Mailer, Toggl::Patches::MailerPatch]
  ].each do |classname, modulename|
    unless classname.included_modules.include?(modulename)
      classname.send(:include, modulename)
    end
  end

end
