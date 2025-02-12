# frozen_string_literal: true

RSpec.describe(Jekyll::ImageCache) do
  Jekyll.logger.log_level = :error

  let(:site) do
    Jekyll::Site.new(Jekyll.configuration(
                       "skip_config_files" => false,
                       "source"            => unit_fixtures_dir,
                       "destination"       => unit_fixtures_dir("_site")
                     ))
  end

  let(:posts) { site.posts.docs.sort.reverse }

  let(:post_with_multiple_markdown_images) do
    find_by_title(posts, "Post with multiple markdown images")
  end

  let(:post_with_img) { find_by_title(posts, "Post with html <img> tag") }

  let(:post_with_loading_img) do
    find_by_title(posts, "Post with cached html <img> tag")
  end

  let(:post_with_relative_img) do
    find_by_title(posts, "Post with relative img url")
  end

  let(:document_with_liquid_tag) do
    find_by_title(site.collections["docs"].docs, "Document with liquid tag")
  end

  let(:document_with_include) do
    find_by_title(site.collections["docs"].docs, "Document with include")
  end

  let(:page_nothing) { find_by_title(site.pages, "Nothing").output }

  before(:each) do
    site.reset
    site.read
    (site.pages | posts | site.docs_to_write).each { |p| p.content.strip! }
    site.render
  end

  it "should not break the html structure" do
    expect(site.pages.first.output).to include(
      "<html",
      "<body",
      "<div>Layout content started.</div>",
      "<div>Layout content ended.</div>",
      "</body>",
      "</html>"
    )
  end

  context "without cache url" do
    it do
      expect(post_with_multiple_markdown_images.output).to include(<<~HTML)
        <ol>
          <li><img src="//images.weserv.nl/?url=via.placeholder.com/150&amp;w=640" alt="alt" class="u-photo"></li>
          <li><img src="https://via.placeholder.com/250" alt="alt" class="not-u-photo"></li>
          <li><img src="//images.weserv.nl/?url=via.placeholder.com/350&amp;w=640" alt="alt" class="u-photo something-else"></li>
        </ol>
      HTML
    end

    context "with img" do
      it "changes src to cached url" do
        expect(post_with_img.output).to include(<<~HTML)
          <p><img src="//images.weserv.nl/?url=via.placeholder.com/150&amp;w=640" class="u-photo"></p>
        HTML
      end
    end

    context "with img with liquid tags" do
      it "changes src to cached url" do
        expect(document_with_liquid_tag.output).to include(<<~HTML)
          <p>This <img src="/docs/document-with-liquid-tag.html"> is an image with a liquid tag.</p>
        HTML
      end

      it "changes relative src to cached url" do
        expect(post_with_relative_img.output).to include(<<~HTML)
          <p><img src="//images.weserv.nl/?url=example.com/imgs/example.png&amp;w=640" alt="alt" class="u-photo"></p>
        HTML
      end
    end

    context "with img within includes" do
      it "changes src to cached url" do
        expect(document_with_include.output).to include(<<~HTML)
          <p>This is a document with an include: This is an include. It has an image. <img src="//images.weserv.nl/?url=via.placeholder.com/150&amp;w=640" alt="" class="u-photo"></p>
        HTML
      end
    end
  end

  context "with cache url" do
    context "with img" do
      it "does not change src" do
        expect(post_with_loading_img.output).to include(<<~HTML)
          <p><img src="//images.weserv.nl/?url=via.placeholder.com/150&amp;w=640" class="u-photo"></p>
        HTML
      end
    end
  end

  context "without any img" do
    it "does not change the markup" do
      expect(page_nothing).to include(<<~HTML)
        <p>Nothing to do in here.</p>
      HTML
    end
  end
end
