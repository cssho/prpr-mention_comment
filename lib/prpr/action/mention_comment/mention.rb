module Prpr
  module Action
    module MentionComment
      class Mention < Base
        REGEXP = /@[a-zA-Z0-9_-]+/

        def call
          if mention?
            Publisher::Adapter::Base.broadcast message
          end
        end

        protected

        def message
          Prpr::Publisher::Message.new(body: body, from: from, room: room)
        end

        def mention?
          comment.body =~ REGEXP
        end

        def body
          <<-END
#{comment_body}

#{comment.html_url}
          END
        end

        def comment_body
          comment.body.gsub(REGEXP) { |old|
            "<" + (members[old] || (members[old.sub!(/@/, '#')].nil? ? nil : "!subteam^#{members[old.sub!(/@/, '#')]}") || old) + ">"
          }
        end

        def comment
          event.comment
        end

        def from
          event.sender
        end

        def room
          env[:mention_comment_room]
        end

        def members
          @members ||= config.read(name).lines.map { |line|
            if line =~ / \* (\S+):\s*(.+)/
              [$1, $2]
            end
          }.to_h
        rescue
          @members ||= {}
        end

        def config
          @config ||= Config::Github.new(repository_name, branch: default_branch)
        end

        def env
          Config::Env.default
        end

        def name
          env[:mention_comment_members] || 'MEMBERS.md'
        end

        def repository_name
          event.repository.full_name
        end

        def default_branch
          event.repository.default_branch
        end
      end
    end
  end
end
