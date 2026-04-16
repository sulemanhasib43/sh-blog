# Gemini CLI Context: superComputer Blog

This project is a personal blog built using **Jekyll** and the [**Chirpy**](https://github.com/cotes2020/jekyll-theme-chirpy) theme. It is managed by Suleman Hasib and covers topics such as Technology, AI, DevOps, Linux, and Apple.

## Project Overview

*   **Type:** Jekyll Blog
*   **Theme:** `jekyll-theme-chirpy`
*   **URL:** [https://blog.samuraihack.win](https://blog.samuraihack.win)
*   **Main Technologies:** Jekyll, Ruby, Liquid, WebP, GitHub Actions.
*   **Key Features:** PWA support, Giscus comments, Google Analytics, SEO optimization, and automatic "last modified" timestamps via Git.

## Building and Running

### Prerequisites
*   Ruby and Bundler installed.
*   Run `bundle install` to install dependencies.

### Development Commands
*   **Start Local Server:**
    ```bash
    bash tools/run.sh
    # OR
    bundle exec jekyll serve -l
    ```
*   **Build Project:**
    ```bash
    bundle exec jekyll build
    ```
*   **Run Tests (Build + HTML Proofer):**
    ```bash
    bash tools/test.sh
    ```

## Development Conventions

### Content Creation
This project uses `jekyll-compose` to manage posts and drafts.
*   **Create a new post:** `bundle exec jekyll post "Post Title"`
*   **Create a new draft:** `bundle exec jekyll draft "Draft Title"`
*   **Publish a draft:** `bundle exec jekyll publish _drafts/my-draft.md`

### Images
*   Store images in `assets/img/`.
*   **Optimization:** Use `tools/cwebp.sh` to convert images to WebP format to maintain performance.
    ```bash
    bash tools/cwebp.sh assets/img/your-image.png
    ```

### Post Metadata
*   **Last Modified:** The `_plugins/posts-lastmod-hook.rb` automatically sets the `last_modified_at` field in posts based on their last Git commit date.
*   **Front Matter:** Refer to `_config.yml` under `jekyll_compose` for default front matter settings.

## Directory Structure & Key Files

*   `_posts/`: Published blog posts (Format: `YYYY-MM-DD-title.md`).
*   `_drafts/`: Work-in-progress posts.
*   `_tabs/`: Main navigation pages (About, Archives, Categories, Tags).
*   `_data/`: Configuration data for contact and sharing.
*   `_plugins/`: Custom Jekyll hooks and plugins.
*   `assets/img/`: Image assets used in posts.
*   `tools/`: Utility scripts for development workflows.
*   `_config.yml`: Central site configuration.
*   `Gemfile`: Project dependencies (RubyGems).
