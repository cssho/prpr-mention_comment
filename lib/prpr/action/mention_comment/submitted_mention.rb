module Prpr
  module Action
    module MentionComment
      class SubmittedMention < Mention
        private
        def comment
          event.review
        end
      end
  end
end