module Prpr
  module Action
    module MentionComment
      class SubmittedMention < Mention
        protected
        def comment
          puts event.review.body
          event.review
        end
      end
  end
end