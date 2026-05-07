module ApplicationHelper
  MARKDOWN_RENDERER = Redcarpet::Render::HTML.new(
    hard_wrap:        true,
    link_attributes:  { target: "_blank", rel: "noopener noreferrer" }
  )

  MARKDOWN = Redcarpet::Markdown.new(
    MARKDOWN_RENDERER,
    autolink:           true,
    tables:             true,
    fenced_code_blocks: true,
    strikethrough:      true,
    highlight:          true,
    superscript:        true,
    no_intra_emphasis:  true
  )

  ALLOWED_TAGS = %w[
    p br strong em del code pre ul ol li blockquote
    h1 h2 h3 h4 h5 h6 table thead tbody tr th td a hr span sup mark
  ].freeze

  ALLOWED_ATTRS = %w[href class target rel].freeze

  def markdown(text)
    return "" if text.blank?
    sanitize(MARKDOWN.render(text), tags: ALLOWED_TAGS, attributes: ALLOWED_ATTRS)
  end
end
