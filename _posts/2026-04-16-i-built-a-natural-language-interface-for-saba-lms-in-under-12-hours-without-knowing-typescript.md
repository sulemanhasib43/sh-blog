---
title: "I Built a Natural Language Interface for SABA LMS in Under 12 Hours (Without Knowing TypeScript)"
date: 2026-04-16 09:00:00 +0800
categories: [GENERATIVE_AI, ARTIFICIAL_INTELLIGENCE]
tags: [mcp, model-context-protocol, typescript, saba, lms, claude, claude-code, ai, automation, markitdown]
author: suleman_hasib
description: How I used MCP, Claude Code, and a spec-first workflow to build a natural language interface for SABA LMS in under 12 hours — without writing a single line of TypeScript myself.
image:
  path: /assets/img/mcp-saba-lms-claude.png
  alt: Natural language interface for SABA LMS using MCP
---

There is a moment in every side project where you stop and think: did I just ship that? This was one of those moments.

My peer teams runs learning programs on SABA LMS, and getting any meaningful data out of it meant navigating a REST API designed for machines, not questions. "Who has completed the program?" required knowing the right endpoint, the right filters, and the patience to page through results and stitch them together. Nobody on the team wanted to do that every time a coordinator asked for a status update.

I had heard of MCP (Model Context Protocol) before. I had even written about it. But I had never built a server. And the SDK is TypeScript-first.

I do not write TypeScript.

Twelve hours later, I had a working MCP server in production.

---

## What is MCP (in one paragraph)

MCP is a protocol that lets AI models talk to external systems through a standardized interface. You define tools, each with a name, a description, and an input schema. The AI model calls those tools by name, passes the right parameters, and your server executes the logic and returns a result. Think of it as a clean contract between "what the AI wants to know" and "where the data actually lives." If you want the longer version, I wrote about it in my previous post: [Understanding the Model Context Protocol (MCP): The USB-C for AI Applications]({% post_url 2025-05-12-understanding-the-model-context-protocol-mcp-the-usb-c-for-ai-applications %}).

---

## The Problem with SABA's API

SABA LMS has a REST API. It is functional, documented, and entirely transactional. To answer a question like "how far along is each learner in this curriculum?", the naive approach involves fetching the curriculum, querying enrollments, then iterating over each person and pulling their transcript individually.

For a cohort of 30 learners, that is roughly 2,800 API calls to get one answer.

The API was not built for analytics. It was built for record management. What I wanted was something simpler: ask a question in plain English, get a clean answer.

---

## Step Zero: Making the API Docs Usable

SABA ships its API documentation as a PDF. Before writing a single line of code, I fed that PDF to Claude Code with one instruction: use the Microsoft [markitdown](https://github.com/microsoft/markitdown) Python package to convert it to Markdown.

That single step changed everything. Instead of flipping between a PDF viewer and a code editor, Claude Code had the full API surface as structured text it could reason over directly. Every endpoint, every parameter, every response shape — all queryable in context.

If you are building any integration from PDF documentation, do this first. It costs five minutes and pays back immediately.

---

## The Build: Spec-First, Keyboard-Minimal

Here is how the actual build worked, and this is the part I want to be precise about because it is not how most developers would describe their process.

I did not write the code. I did not review the code. I wrote a spec.

I described to Claude Code what I wanted: an MCP server that wraps the SABA REST API, with tools covering the key questions my team asks most often. People search, enrollment lookup, transcript retrieval, certification status, curriculum progress. I described the shape of each tool: what it takes as input, what it should return, how errors should be handled.

Claude Code built it.

Then I deployed it to Claude Desktop and started asking questions.

---

## The Feedback Loop That Actually Worked

This is the workflow that made the 12-hour timeline possible, and it is worth describing carefully.

After each test in Claude Desktop, I did not go looking for errors or open a terminal. Instead, I asked Claude Desktop directly: "summarize your findings from that test so I can share them with claude code."

Claude Desktop would return a structured summary: what worked, what failed, what the response shape looked like, and where the behavior diverged from expectation. I copied that summary and pasted it into Claude Code as my next message.

Claude Code read the findings, identified the issue, and updated the implementation. I deployed the new build, ran the next test, and repeated.

The loop looked like this:

```
Spec → Build → Deploy to Claude Desktop → Test →
Ask Claude Desktop for findings summary →
Paste into Claude Code → Fix → Deploy → Repeat
```

Two AI tools. One passing notes to the other. Me in the middle making judgment calls about whether the answers made sense.

The human role in this loop is not implementation. It is domain judgment: does this answer make sense? Is this the right question to ask? Is this data trustworthy?

That is a meaningful shift.

---

## The Tool That Proved It

The most important tool I specified was `get_curriculum_progress`. Given a curriculum ID, it should return completion status for every enrolled learner in one call.

Here is the key snippet from what Claude Code produced:

```typescript
server.tool(
  "get_curriculum_progress",
  "Returns per-learner completion progress for a given curriculum",
  {
    curriculum_id: z.string().describe("The SABA curriculum ID")
  },
  async ({ curriculum_id }) => {
    const results = await sabaClient.getCurriculumProgress(curriculum_id);
    return { content: [{ type: "text", text: JSON.stringify(results) }] };
  }
);
```

Underneath, it calls two SABA endpoints and normalizes the response into a flat, readable shape with fields like `person_name`, `percent_completed`, `status`, and `target_date`. Two API calls. One clean answer. The 2,800-call problem gone.

---

## The Moments That Made It Worth It

The first came when I started querying a single learner's history out of curiosity. What came back was not a table of course completions. It was a story.

This learner had spent years heavily invested in platform and infrastructure topics. Then in 2025, something shifted. AI-related courses started appearing, slowly at first, then accelerating. The completion pattern changed too: long quiet periods followed by intense bursts of activity, year-end catch-ups that suggested deadline-driven motivation, and a clear trajectory of someone actively repositioning themselves.

None of that was visible in any report. The data existed in the LMS the entire time, scattered across enrollment records and completion timestamps. It just had no way to speak. Giving it a natural language interface changed that. The patterns were always there. We just could not ask for them.

The second example is harder to ignore from a pure efficiency standpoint.

A colleague needed a cohort completion report. Their process: contact an LMS admin, request a CSV export, wait, receive the file, organize the columns, clean the data, format it into something presentable. Two days, start to finish, most of it waiting.

The same report took five minutes by querying Claude Desktop through the MCP server.

But the more interesting part is what happened next. Once the data was in a conversational interface, the questions got better. Not just "how many people completed" but "which course did participants struggle to finish?" and "who completed everything except one module?" and "which learners are at risk of not finishing before the deadline?"

Those questions would never have been asked in the old workflow. The friction of getting a CSV export meant people asked the minimum. Remove the friction and the questions get smarter.

That is the real shift. Not automation. Curiosity at scale.

---

## The Pattern, Generalized

If you have any system with a REST API and data your team accesses through reports, spreadsheets, or manual queries, this pattern is worth trying:

1. Convert your API docs to Markdown using Microsoft [markitdown](https://github.com/microsoft/markitdown)
2. Write a spec describing the questions you want answered, not the endpoints you want called
3. Let Claude Code build the MCP server
4. Deploy to Claude Desktop and test with real data
5. Ask Claude Desktop for a structured findings summary after each test
6. Paste that summary into Claude Code and iterate

The barrier to building this kind of tooling used to be: do you know the language, the SDK, the patterns? That barrier has moved. What matters now is whether you understand the system you are integrating with and can reason clearly about what a good answer looks like.

The SABA MCP server now has tools for searching people, pulling enrollments, checking certifications, and querying curriculum progress. What started as a 12-hour experiment is now the primary way my team gets answers out of the LMS.

The spreadsheet is still there. Nobody updates it anymore.

---

*BTW: This blog was deployed and updated on GitHub using [gemini-cli](https://github.com/google-gemini/gemini-cli).*
