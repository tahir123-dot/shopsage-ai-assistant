# ShopSage

An AI-powered shopping assistant. Ask for products in plain language (English or Roman Urdu) and get a short, friendly answer along with product cards.

The Flutter app talks to a Node.js + TypeScript backend. The backend uses an LLM with **tool calling** to search a product catalog (DummyJSON) and returns a reply plus the matching products.

## Features

- Chat UI with user and bot bubbles, typing indicator and a welcome screen
- Product cards (image, category, price, favorite and cart buttons)
- LLM agent loop with tool calling: search products, filter by category, list categories
- Replies in the user's language (including Roman Urdu)
- Drawer, suggestion chips and model dropdown (UI only for now)

## Tech stack

| Part | Technology |
|---|---|
| App | Flutter, Dart, `http` |
| Backend | Node.js, Express, TypeScript, `tsx` |
| LLM | Groq API (OpenAI-compatible) via the `openai` package |
| Data | [DummyJSON](https://dummyjson.com/products) |

## How it works

```
Flutter app  ->  POST /chat  ->  Express server
                                      |
                                      v
                          LLM decides which tool to call
                                      |
                                      v
                     Tool fetches products from DummyJSON
                                      |
                                      v
              LLM writes a short reply  ->  { reply, products }
```

The server runs the tools itself. The LLM only chooses which tool to call and with what arguments.

## Project structure

```
shopsage-ai/
├── backend/
│   └── src/
│       ├── index.ts     # Express server, POST /chat
│       ├── agent.ts     # LLM + agent loop
│       └── tools.ts     # DummyJSON tools
└── app/
    └── lib/
        ├── core/        # constants, theme
        ├── models/      # Product, Message
        ├── services/    # chat API service
        ├── utils/       # helpers
        ├── widgets/     # reusable UI parts
        └── screens/     # chat screen
```

## Getting started

### 1. Backend

```bash
cd backend
npm install
cp .env.example .env     # on Windows: copy .env.example .env
```

Open `.env` and add your key from [console.groq.com](https://console.groq.com):

```
GROQ_API_KEY=your_groq_api_key_here
GROQ_MODEL=openai/gpt-oss-120b
PORT=3001
```

Start the server:

```bash
npm run dev
```

Quick test (PowerShell):

```powershell
Invoke-RestMethod -Uri http://localhost:3001/chat -Method Post -ContentType "application/json" -Body '{"message":"show me a good phone"}'
```

### 2. Flutter app

```bash
cd app
flutter pub get
```

Set the server address in `app/lib/core/constants.dart`:

| Where you run the app | `baseUrl` |
|---|---|
| Android emulator | `http://10.0.2.2:3001` |
| Real phone (same Wi-Fi) | `http://<YOUR_PC_IP>:3001` |
| Chrome / Windows | `http://localhost:3001` |

Then run:

```bash
flutter run
```

For a real phone, allow port 3001 in your firewall and make sure `android:usesCleartextTraffic="true"` is set in `AndroidManifest.xml` (plain `http` is used in development).

## API

### `POST /chat`

Request:

```json
{ "message": "show me a good phone" }
```

Response:

```json
{
  "reply": "I found some good options. ...",
  "products": [
    {
      "id": 123,
      "title": "iPhone 13 Pro",
      "price": 1099.99,
      "category": "smartphones",
      "thumbnail": "https://..."
    }
  ]
}
```

## Notes

- Never commit your `.env` file. Only `.env.example` is tracked.
- Free LLM tiers and model names change over time. If you get a `model_not_found` error, pick a current model from the provider's model list and update `GROQ_MODEL`.
- Each request is independent for now (no chat memory).

## Roadmap

- [ ] Send chat history so follow-up questions work
- [ ] Working cart and favorites
- [ ] Voice input
- [ ] Deploy the backend (HTTPS)

## License

MIT