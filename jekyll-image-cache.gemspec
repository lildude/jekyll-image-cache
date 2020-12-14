# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll-image-cache/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-image-cache"
  spec.version = Jekyll::ImageCache::VERSION
  spec.authors = ["Colin Seymour"]
  spec.summary = "Cache and resize images via images.weserv.nl."
  spec.homepage = "https://github.com/lildude/jekyll-image-cache"
  spec.license = "MIT"
  spec.files = Dir["{lib}/**/*.*", "*.md"]
  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/lildude/jekyll-image-cache/issues",
  }
  spec.require_paths = %w(lib)
  spec.add_dependency "jekyll", ">= 3.0", "< 5.0"
  spec.add_dependency "nokogiri", ">= 1.10", "< 2.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "< 1.0"
  spec.add_development_dependency "rubocop-jekyll", "< 1.0"
end
