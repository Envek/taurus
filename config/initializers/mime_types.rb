# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

# Make rails understand the markdown format
Mime::Type.register "text/x-markdown", :markdown, %w( text/x-web-markdown text/markdown ), %w( md mdown )
