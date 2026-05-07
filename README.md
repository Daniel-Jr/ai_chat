# AI Chat

A real-time AI chat application built with Rails 8, streaming responses from a local [Ollama](https://ollama.com) instance via [ruby_llm](https://github.com/crmne/ruby_llm). Each user has their own private chat history. Messages stream token-by-token directly to the browser over Action Cable.

## Stack

| Layer | Technology |
|---|---|
| Framework | Rails 8.1 |
| Language | Ruby 3.4 |
| Database | SQLite (via Solid Cache / Solid Queue / Solid Cable) |
| Auth | Devise |
| AI | ruby_llm → Ollama (llama3.2) |
| Real-time | Action Cable (Turbo Streams) |
| Frontend | Importmap + Stimulus + Tailwind CSS v4 |
| Markdown | Redcarpet (GFM) |

---

## Prerequisites

- Ruby 3.4
- Bundler
- [Ollama](https://ollama.com/download) installed and running
- The `llama3.2` model pulled locally

---

## Setup

### 1. Clone and install dependencies

```bash
git clone <repo-url>
cd ai_chat
bundle install
```

### 2. Pull the AI model

```bash
ollama pull llama3.2
```

### 3. Set up the database

```bash
bin/rails db:setup
```

### 4. Start Ollama

```bash
ollama serve
```

### 5. Start the app

```bash
bin/dev
```

Open [http://localhost:3000](http://localhost:3000), sign up, and start chatting.

---

## Environment Variables

All variables are optional — the defaults work out of the box with a local Ollama installation.

| Variable | Default | Description |
|---|---|---|
| `OLLAMA_API_BASE` | `http://localhost:11434/v1` | Ollama API endpoint |
| `DEFAULT_MODEL` | `llama3.2` | Model name passed to Ollama |
| `SECRET_KEY_BASE` | — | Required in production |

To override, create a `.env` file or export variables before running `bin/dev`.

---

## Using a Different Model

Any model supported by Ollama works. Pull it first, then set the env var:

```bash
ollama pull mistral
DEFAULT_MODEL=mistral bin/dev
```

---

## Features

- **User accounts** — sign up, sign in, edit account, reset password
- **Multiple chats** — create as many conversations as you like; sidebar updates live
- **Auto-title** — the chat title is set automatically from the first message
- **Streaming responses** — assistant replies stream token-by-token, no page reload
- **Markdown rendering** — responses are rendered as GFM (bold, italic, code blocks, tables, lists, links)
- **Dark mode** — follows the OS preference

---

## Project Structure

```
app/
├── controllers/
│   ├── chats_controller.rb       # CRUD for chats
│   └── messages_controller.rb   # Creates messages, enqueues streaming job
├── helpers/
│   └── application_helper.rb    # markdown() helper (Redcarpet)
├── jobs/
│   └── chat_stream_job.rb       # Streams AI response via Action Cable
├── models/
│   ├── chat.rb                  # acts_as_chat, sidebar broadcast
│   ├── message.rb               # acts_as_message, streaming broadcast
│   └── user.rb                  # Devise user
├── javascript/controllers/
│   ├── chat_scroll_controller.js   # Auto-scroll on new messages
│   ├── message_form_controller.js  # Enter to send, clear on submit
│   ├── autogrow_controller.js      # Textarea auto-resize
│   ├── sidebar_controller.js       # Mobile sidebar toggle
│   └── flash_controller.js         # Auto-dismiss flash messages
└── views/
    ├── chats/                   # Chat list, show, sidebar partials
    ├── messages/                # Message bubbles, form, streaming partial
    └── devise/                  # Tailwind-styled auth views
```

---

## How Streaming Works

1. User submits a message → `MessagesController#create` saves it and enqueues `ChatStreamJob`
2. The job calls `chat.complete` (ruby_llm) with a streaming block
3. Each chunk is accumulated and broadcast via `broadcast_replace_to "chat_#{id}"` replacing the assistant's bubble content in real time
4. On completion, `after_update_commit` re-broadcasts the final message and updates the sidebar order

---

## Development Notes

- Background jobs run in-process via `AsyncAdapter` in development — no separate worker needed
- Solid Cable uses SQLite as the Action Cable backend — no Redis needed
- `Message.suppressing_turbo_broadcasts` prevents duplicate WebSocket delivery of the user message (already appended via the HTTP Turbo Stream response)
- `assume_model_exists: true` and `provider: :ollama` must be set on every `Chat` instance before calling `complete` — ruby_llm will raise `ModelNotFoundError` otherwise
