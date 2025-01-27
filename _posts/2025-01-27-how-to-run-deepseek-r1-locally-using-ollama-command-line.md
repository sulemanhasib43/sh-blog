---
layout: post
title: How to run DeepSeek-R1 locally Using Ollama Command Line
date: 2025-01-27
categories: [GENERATIVE_AI, ARTIFICIAL_INTELLIGENCE]
tags: [deepseek, r1, local, llm, genrative, general, ai, ollama, chatgpt, chinese, linux, windows, mac, model]
image:
  path: "/assets/img/run-deepseek-r1-locally.webp"
  alt: 'How to run DeepSeek-R1 locally Using Ollama Command Line'
---
## What is DeepSeek-R1
DeepSeek-R1 is an advanced AI developed by DeepSeek, designed to excel in a wide range of tasks such as question 
answering, natural language understanding, and problem-solving. Its superior performance across multiple domains 
makes it a valuable tool for researchers and professionals alike.

## How it compares to other LLM Models

DeepSeek-R1 has indeed demonstrated remarkable advancements, particularly in its ability to process and understand 
complex queries efficiently. It surpasses all prior models by achieving faster execution times on various tasks, 
making it a pivotal step toward achieving general AI.
![DeepSeek-R1 Comparison to OpenAI](/assets/img/deepseek-r1-comparison.webp)

## How to Run DeepSeek R1 Locally Using Ollama Command Line

Running **DeepSeek R1** locally using the Ollama command line is a straightforward process that enables you to experiment with this advanced model on your own machine. This guide will walk you through the steps, ensuring you have a seamless setup and execution.

---

### Step 1: Download and Install the Ollama Client

1. Visit [Ollama’s website](https://ollama.com) to download the client for your operating system.
2. Follow the installation instructions provided. During the installation, you will be prompted to set up the command line interface and provide admin credentials.

---

### Step 2: Verify Ollama Server is Running

After installation, open your terminal and execute the following command to confirm that the Ollama server is operational: 

```bash
ollama serve
```

#### Expected Output:
If the server is already running, you will see an error message similar to this:

```bash
Error: listen tcp 127.0.0.1:11434: bind: address already in use
```

This error simply means the server is up and running, so you’re good to proceed.

---

### Step 3: Navigate to the DeepSeek R1 Model Page

Next, visit the [DeepSeek R1 model page](https://ollama.com/library/deepseek-r1) to access the model details.

![DeepSeek Models on Ollama](/assets/img/ollama-models-deepseek-r1.webp)

---

### Step 4: Download and Run the Model

In your terminal, download and run the DeepSeek R1 model by using the following command:

```bash
ollama run deepseek-r1:1.5b
```

> **Tip:** The `1.5b` tag refers to the model version with 1.5 billion parameters. You can adjust this tag based on the model version you prefer.

---

### Step 5: Wait for the Download to Complete

The terminal will display a progress log as the model is downloaded. Once the download is complete, the model will automatically begin running.

```bash
pulling manifest 
pulling aabd4debf0c8... 100% ▕███████████████████████████████████████████████████████████▏ 1.1 GB                         
pulling 369ca498f347... 100% ▕███████████████████████████████████████████████████████████▏  387 B                         
pulling 6e4c38e1172f... 100% ▕███████████████████████████████████████████████████████████▏ 1.1 KB                         
pulling f4d24e9138dd... 100% ▕███████████████████████████████████████████████████████████▏  148 B                         
pulling a85fe2a2e58e... 100% ▕███████████████████████████████████████████████████████████▏  487 B                         
verifying sha256 digest 
writing manifest 
success 
```
---

## That’s it! Start Experimenting with DeepSeek R1

```bash
>>> Send a message (/? for help)
```

Congratulations! You’ve successfully set up and run the **DeepSeek R1** model locally using the Ollama command line. You can now start leveraging its capabilities for your projects.

**Happy Hacking!** 🚀

