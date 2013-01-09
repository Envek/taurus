# -*- encoding : utf-8 -*-
require "markdown_templates_handler"

ActionView::Template.register_template_handler :md, MarkdownHandler
ActionView::Template.register_template_handler :markdown, MarkdownHandler
ActionView::Template.register_template_handler :mdown, MarkdownHandler
