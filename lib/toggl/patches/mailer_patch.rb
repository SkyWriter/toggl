require_dependency 'mailer'


module Toggl
  module Patches
    module MailerPatch
      def self.included(base) # :nodoc:
        # base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable  # to make sure plugin is loaded in development mode
        end
      end

      module InstanceMethods

        def toggl_missmatch_report_mail(cc_mails, lang, all_users_missmatch_toggl_entries)
          @all_users_missmatch_toggl_entries = all_users_missmatch_toggl_entries
          I18n.locale = lang

          mail :to => cc_mails,
            :subject => 'Toggl-Redmine Missmatch Report'
        end

      end
    end
  end
end
