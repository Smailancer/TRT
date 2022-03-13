class Tweet < ApplicationRecord
    include PublicActivity::Model

    belongs_to :user 
    acts_as_votable
    
    validates_presence_of :content
    validates_length_of :content, maximum: 280

    FORMAT = AutoHtml::Pipeline.new(
        AutoHtml::HtmlEscape.new,
        AutoHtml::Link.new(target: '_blank', rel: 'nofollow'),
        AutoHtml::SimpleFormat.new
      )
    
      def content=(c)
        super(c)
        self[:content_html] = FORMAT.call(t)
      end
end
