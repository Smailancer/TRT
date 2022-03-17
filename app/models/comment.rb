class Comment < ActiveRecord::Base
  include PublicActivity::Model
  include ActsAsCommentable::Comment
  after_create :resolve_mentions
  belongs_to :commentable, :polymorphic => true

  default_scope -> { order('created_at ASC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  validates_presence_of :comment

  FORMAT = AutoHtml::Pipeline.new(
    AutoHtml::HtmlEscape.new,
    AutoHtml::Link.new(target: '_blank', rel: 'nofollow'),
    AutoHtml::SimpleFormat.new
  )

  def comment=(c)
    super(c)
    self[:comment] = FORMAT.call(c)
  end

  def resolve_mentions
    mentions = comment.scan(/@\w+/)
    mentions.uniq.map do |match|
      mention = find_mention(match)

      next unless mentions
      update_attributes!(comment: replace_mention_with_url(mention, comment))
    end
  end

  def find_mention(match)
    user = User.find_by(username: match.delete('@'))
    user if user.present?
  end

  def replace_mention_with_url(mention, content)
      content.gsub(/@#{mention.username}/,
                    "<a href='#{Rails.application.routes.url_helpers.user_path(mention.username)}' target='_blank'>@#{mention.username} </a>")
  end
end
