# frozen_string_literal: true

require "jekyll"
require "nokogiri"

module Jekyll
  class ImageCache
    extend Jekyll::Filters::URLFilters

    def self.process(content)
      @context ||= Context.new(content.site)
      html = content.output
      content.output = process_tags(html) if process_tags?(html)
    end

    def self.process?(doc)
      (doc.is_a?(Jekyll::Page) || doc.write?) && doc.output_ext == ".html" ||
        doc.permalink&.end_with?("/")
    end

    def self.process_tags?(html)
      html.include?("<img")
    end

    def self.process_tags(html)
      content = Nokogiri.HTML(html)
      # TODO: Make the tag configurable
      tags = content.css("img[src].u-photo")
      # TODO: Make the cache service and size configurable
      tags.each do |tag|
        orig_url = absolute_url(tag["src"]).sub(%r!https?://!, "")
        unless orig_url.include? "images.weserv.nl"
          tag["src"] = "//images.weserv.nl/?url=#{orig_url}&w=640"
        end
      end
      content.to_html
    end

    private_class_method :process_tags
    private_class_method :process_tags?
  end

  class Context
    attr_reader :site

    def initialize(site)
      @site = site
    end

    def registers
      { :site => site }
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  Jekyll::ImageCache.process(doc) if Jekyll::ImageCache.process?(doc)
end
