# jekyll-image-cache

A Jekyll plugin that updates specific image links to be served and resized through <https://images.weserv.nl/>.

## Installation

1. Add the following to your site's `Gemfile`:

   ```ruby
   gem 'jekyll-image-cache'
   ```

2. add the following to your site's `_config.yml`:

   ```yml
   plugins:
     - jekyll-image-cache
   ```

   **Note**: if `jekyll --version` is less than `3.5` use:

   ```yml
   gems:
     - jekyll-image-cache
   ```

3. In your terminal, execute:

   ```bash
   bundle
   ```

4. (re)start your Jekyll server with:

   ```bash
   jekyll serve
   ```

## Usage

Add the `u-photo` class to any image you wish to be cached and resized (width of 640px) on <https://images.weserv.nl/>, either using Markdown syntax:

```liquid
![Image alt](https://example.com/images/photo.jpg){:class="u-photo"}
```

... or HTML syntax:

```html
<img src="https://example.com/images/photo.jpg" alt="Image alt" class="u-photo">
```

The resulting images will be rendered with a `src` URL of: `//images.weserv.nl/?url=example.com/images/photo.jpg&w=640`


**💡 Tip:** Note that the `github-pages` gem runs in `safe` mode and only allows [a defined set of plugins](https://pages.github.com/versions/). To use this gem in GitHub Pages, you need to build your site locally or use a CI (e.g. [Github Workflow](https://help.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow)) and deploy to your `gh-pages` branch. [Click here for more information.](https://jekyllrb.com/docs/continuous-integration/github-actions/)

---

## TODO

- [ ] Make caching service configurable
- [ ] Make image sizing etc options configurable