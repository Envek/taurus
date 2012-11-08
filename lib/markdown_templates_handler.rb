require 'redcarpet'

module MarkdownHandler
  def self.erb
    @erb ||= ActionView::Template.registered_template_handler(:erb)
  end

  def self.parser
    unless @markdown_parser
      options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
      @markdown_parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, Hash[options.map{|o| [o, true]}])
    end
    @markdown_parser
  end

  def self.call(template)
    compiled_source = erb.call(template)
    "MarkdownHandler.parser.render(begin;#{compiled_source};end).html_safe"
  end
end
