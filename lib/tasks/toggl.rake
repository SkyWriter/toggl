namespace :toggl do

  desc "update Toggl information"
  task :update => [:environment] do
    TogglSyncService.new.sync
  end

  desc "report missmatch Toggl and Redmine entries"
  task :report, [:time_interval, :lang, :cc_mails] => [:environment, :update] do |t, args|
    unless args.time_interval && args.cc_mails
      fail "You need the specify time_interval, language and cc_mail(s)."
    end
    time_interval = (Time.now - args.time_interval.to_i.hours)
    lang = args.lang
    # Rake splits arguments with comma, join them together to use
    cc_mails = "#{args.cc_mails}, #{args.extras.join(', ')}"
    TogglSyncService.new.report(cc_mails, lang, time_interval)
	end
end
