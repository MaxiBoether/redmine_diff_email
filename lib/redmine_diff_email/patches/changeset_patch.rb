require_dependency 'changeset'

module RedmineDiffEmail
  module Patches
    module ChangesetPatch

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          after_create :send_notification
        end
      end

      module InstanceMethods

        private

        def send_notification
          if repository.is_diff_email?
            unless self.user.nil?
              Mailer.changeset_added(self.user, self, repository.is_diff_email_attached?).deliver
            end
          end
        end

      end

    end
  end
end

unless Changeset.included_modules.include?(RedmineDiffEmail::Patches::ChangesetPatch)
  Changeset.send(:include, RedmineDiffEmail::Patches::ChangesetPatch)
end
