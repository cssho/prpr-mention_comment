module Prpr
  module Handler
    class MentionComment < Base
      handle Event::IssueComment, action: /created/ do
        Action::MentionComment::Mention.new(event).call
      end

      handle Event::CommitComment, action: /created/ do
        Action::MentionComment::Mention.new(event).call
      end

      handle Event::PullRequestReviewComment, action: /created/ do
        Action::MentionComment::Mention.new(event).call
      end

      handle Event::PullRequestReview, action: /submitted/ do
        Action::MentionComment::SubmittedMention.new(event).call
      end
    end
  end
end
