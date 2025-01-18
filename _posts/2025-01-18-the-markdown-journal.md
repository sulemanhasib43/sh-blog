---
layout: post
title: The Markdown Journal
date: 2025-01-18
categories: [BLOG]
tags: [markdown, blog, jekyll, github, pages, static, cms, docker, vscode, devcontainers, ruby, gem, database, wordpress, hugo, 11ty]
image:
  path: "/assets/img/markdown-journal.webp"
  alt: 'The Markdown Journal'
---

## One Fine Day, I Had an Idea  

I was just sitting around, thinking about my scattered blogs. Medium, Blogger, LinkedIn, and that one-off post on applenow.io—I’ve written all over the place. And then it hit me: why not gather them all in one place and create my own blog?  

But wait, who has the time, energy, or money to set up a full-on WordPress site? I mean, *come on*. Wouldn’t it be nice to have something lightweight, without the hassle of databases, that I could host on GitHub Pages?  

Sure, that sounded great, but then I’d have to write all my blogs in HTML. Yuck. Plus, these days, I mostly live in my note-taking app—[Obsidian](https://obsidian.md/). Imagine how awesome it would be to just write my posts in markdown and have some tool magically turn them into a proper blog? *Too good to be true*, I thought.  

But then I started Googling “static content management systems (CMS).”  

## Hello, Static CMS!  

To my surprise, I got hit with some great recommendations. After digging through Reddit threads and random blog posts, I narrowed it down to three contenders:  

1. **[Hugo](https://gohugo.io/)**  
2. **[11ty](https://www.11ty.dev/)**  
3. **[Jekyll](https://jekyllrb.com/)**  

I gave all three a try, but something about Jekyll just clicked with me. Their homepage spoke directly to my needs:  

- **Simple**: No more databases.  
- **Static**: Write in markdown.  
- **Blog-Aware**: Permalinks, categories, and all that good stuff.  
- **Free Hosting**: Yep, on GitHub Pages.  

That’s it. That’s exactly what I was looking for!  

## Getting Started with Jekyll  

Next, I needed a tutorial to get my feet wet. A quick search on YouTube brought me to **[Giraffe Academy](https://www.giraffeacademy.com/)**, a channel run by this super chill guy Mike who knows his stuff. He has an entire Jekyll playlist: [Jekyll Playlist on YouTube](https://youtube.com/playlist?list=PLLAZ4kZ9dFpOPV5C5Ay0pHaa0RJFhcmcB&si=Utf6NJm4LlxCYJI8).  

I went through most of the videos, and they got me up and running on Jekyll in no time. Setting up my laptop to compose with Jekyll was straightforward and kind of fun.  

## Picking the Perfect Theme  

Then came another exciting part—choosing a theme. I browsed through *a lot* of options, but one theme stood out: **Chirpy** ([Check it out here](https://chirpy.cotes.page/)).  

Why Chirpy?  
- It’s set up with **devcontainers** and **VS Code**—exactly how I work on other projects.  
- The workflow is simple: write your blog, `git commit`, and `git push`. Done.  

It even allows collaborators! They can clone my repo, write a blog, and submit a pull request to get their article published. Seriously, it couldn’t get any easier.  

## Adding Feedback Without a Database  

Now, I know I don’t want a database, but I also don’t want to lose the ability to get feedback and have discussions. So, how do I add comments without going the database route?  

Turns out, you can use **[Giscus](https://giscus.app/)**! It’s a neat little app that integrates with GitHub discussions. Here’s how it works:  
1. Install Giscus in your GitHub repo.  
2. Enable discussions in your repo settings.  
3. Configure the Chirpy theme to use giscuss for comments.  

The best part? Chirpy supports Giscus *out of the box*! Just add the configuration values to your `_config.yml` file, and you’re good to go.  

With this setup, readers can leave comments directly through GitHub discussions, and everything stays clean and lightweight. No extra servers or databases required.  

## The Final Verdict  

So here I am, hosting a clean, simple blog powered by Jekyll, markdown files, and GitHub Pages. No databases, no HTML struggles, no stress. Just me, my notes in Obsidian, and a blog that’s exactly what I wanted.  

If you’re in the same boat I was, give Jekyll a try. And if you need help, Giraffe Academy, Chirpy, and Giscus make the entire process so much easier.  

Trust me, you’ll love it. 😊  

PS: If you're wondering how much time it took me to set this up just 5 hours ⏰!
