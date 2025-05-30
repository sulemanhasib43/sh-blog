---
layout: post
title: How I Automated My Daily Needs Using n8n
date: 30-05-2025
categories: [AUTOMATION, N8N]
tags: [automation, n8n, self-host, devops, workflow, docker, compose, ]
image:
  path: "/assets/img/n8n-banner.webp"
  alt: 'n8n automation workflow for fediverse mastodon and threads'
---

As someone who constantly strives to automate repetitive tasks, I’ve always been on the lookout for tools that simplify workflows. Automating daily needs often required me to code from scratch, set up a boilerplate, and manage scripts. Recently, while exploring the Fediverse, I discovered [n8n](https://n8n.io/), a powerful workflow automation tool. Intrigued, I decided to try it, and it turned out to be a game-changer.

## Setting Up n8n on Docker
Since [Docker](https://www.docker.com) is my go-to tool for deployments, getting started with n8n was a breeze. I deployed it on my self-hosted Fedora Linux system, and the process was straightforward.

Here’s the Docker Compose configuration I used:
<script src="https://gist.github.com/sulemanhasib43/63f208fc42df73396bf63b9d67ea1bca.js"></script>

This setup requires configuring a few environment variables like `NODE_ENV=production`, `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true`, `N8N_RUNNERS_ENABLED=true`, `N8N_EDITOR_BASE_URL=${DOMAIN_NAME}`, `N8N_HOST=${DOMAIN_NAME}`, and `WEBHOOK_URL=https://${DOMAIN_NAME}/`. Once configured, I spun it up with `docker compose up -d`, and just like that, n8n was ready to go.


## My Use Case: Automating Posts Across Fediverse Platforms
I regularly use [threads](https://threads.com), which has [Fediverse](https://jointhefediverse.net) integration, and [mastodon](https://mastodon.social) for social media engagement. However, manually posting or reposting content across these platforms felt tedious. The idea of keeping all my activity centralized appealed to me, and this is where n8n came into play.

With n8n, I automated the process of reposting my **threads** updates to my **mastodon** profile. This setup ensures that any post I create in **threads** gets automatically boosted on **mastodon**. Here’s how I did it:

<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
  <polyline points="7 10 12 15 17 10"/>
  <line x1="12" y1="15" x2="12" y2="3"/>
</svg>

**[Download Template](https://n8n.io/workflows/4397-boost-postsstatuses-from-a-specific-fediverse-account-on-your-mastodon-profile/)**

### How it works
The workflow runs on a scheduled trigger and retrieves recent posts from a specified Fediverse account, such as your Threads.net account. It uses a JavaScript filter to identify posts from the current day and then automatically boosts or reshares them to your selected Mastodon profile.

---

### Preconditions

1. You need a Mastodon account with developer access.
2. Identify a threads.com or other Fediverse account which you want to boost.
3. Basic familiarity with APIs and setting up credentials in n8n.

---

### Setup Steps

#### Step 1: Create a Developer Application on Mastodon

1. Log in to your Mastodon account and navigate to **Preferences > Development > New Application**.
2. Fill out the required information and create your application.
3. Set **Scopes** to atleast `read, profile, write:statuses`.
4. Click submit.
5. Note down the access token generated for this application.

#### Step 2: Get the Account ID

1. Use the following command to retrieve the account ID for the profile you want to boost:

   ```bash
   curl -s "https://mastodon.social/api/v1/accounts/lookup?acct=<ACCOUNTNAME>"
   ```

   Alternatively, paste the URL into a GET node on n8n.
2. From the returned JSON, copy the `"id"` field value (e.g., `{"id":"110564198672505618", ...}`).

#### Step 3: Update the "Get Statuses" Node

1. Replace `ACCOUNTID` in the URL field with the ID you retrieved in Step 2:

   ```
   https://mastodon.social/api/v1/accounts/<ACCOUNTID>/statuses
   ```

#### Step 4: Configure the "Boost Statuses" Node

Authentication type will already be set to **Header Auth**.

1. Grab the access token from Step 1.
2. In the **Credential for Header Auth** field, create a new credential.
3. Click the pencil icon in the top-left corner to name your credential.
4. In the `Name` field, enter `Authorization`.
5. In the `Value` field, enter `Bearer <YOUR_MASTODON_ACCESS_TOKEN>`. (Note: there is a space after "Bearer.")
6. Save the credential, and it should automatically be selected as your Header Auth.

#### Step 5: Test the Workflow

1. Run the workflow to ensure everything is set up correctly.
2. Adjust filters or parameters as needed for your specific use case.

---

### Customization Guidance

* Replace `mastodon.social` with your own Mastodon domain if you're using a self-hosted instance.
* Adjust the JavaScript filter logic to meet your specific needs (e.g., filtering by hashtags or keywords).
* For enhanced security, store the access token as an n8n credential. Embedding it directly in the URL is ++not recommended++.

---

#### Notes

* This workflow is designed to work with any Mastodon domain.
* Ensure your Mastodon account has appropriate permissions for boosting posts.

By following these steps, you can automate your Fediverse engagement and focus on creating meaningful content while the workflow handles the rest!

# Conclusion
n8n has revolutionized how I approach automation. Tasks that once demanded hours of scripting are now simplified into configurable diagrams. Whether you’re an automation enthusiast or a developer looking for efficiency, n8n is worth exploring. Check out the templates available on n8n.io, and take your automation game to the next level.

If you’re like me—someone who believes every repetitive task is an opportunity for automation—you’ll appreciate the versatility and simplicity that n8n brings to the table.
