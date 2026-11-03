import "dotenv/config";
import OpenAI from "openai";
import type {
  ChatCompletionMessageParam,
  ChatCompletionTool,
} from "openai/resources/chat/completions";
import {
  searchProducts,
  getProductsByCategory,
  getCategories,
  type Product,
} from "./tools";

const client = new OpenAI({
  baseURL: "https://api.groq.com/openai/v1",
  apiKey: process.env.GROQ_API_KEY,
});

const MODEL = process.env.GROQ_MODEL ?? "llama-3.3-70b-versatile";

// LLM ko batate hain ke kaun kaun se tools hain
const tools: ChatCompletionTool[] = [
  {
    type: "function",
    function: {
      name: "searchProducts",
      description:
        "Search products by keyword, e.g. 'phone', 'red lipstick', 'laptop'",
      parameters: {
        type: "object",
        properties: {
          query: { type: "string", description: "Search keyword" },
        },
        required: ["query"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "getProductsByCategory",
      description:
        "Get products of one category. Use getCategories first if unsure of the name.",
      parameters: {
        type: "object",
        properties: {
          category: {
            type: "string",
            description: "Category slug, e.g. 'smartphones'",
          },
        },
        required: ["category"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "getCategories",
      description: "List all available product categories",
      parameters: { type: "object", properties: {} },
    },
  },
];

// Tool ka naam -> asli function
async function runTool(name: string, args: any): Promise<unknown> {
  switch (name) {
    case "searchProducts":
      return searchProducts(String(args.query ?? ""));
    case "getProductsByCategory":
      return getProductsByCategory(String(args.category ?? ""));
    case "getCategories":
      return getCategories();
    default:
      return { error: `Unknown tool: ${name}` };
  }
}

export async function runAgent(userMessage: string) {
  const messages: ChatCompletionMessageParam[] = [
    {
      role: "system",
      content:
        "You are a friendly shopping assistant inside a mobile app.\n" +
        "\n" +
        "LANGUAGE: Reply in the same language the user writes in. " +
        "If the user writes Roman Urdu or Roman Hindi (in English letters), " +
        "reply in Roman Urdu using English letters only. " +
        "Never use Devanagari or Arabic script unless the user does.\n" +
        "\n" +
        "TOOLS: When the user wants a type of product, call getCategories first " +
        "if you are not sure of the exact category name, then use getProductsByCategory. " +
        "For example, phones are in the 'smartphones' category. " +
        "Use searchProducts only for specific keywords or brand names. " +
        "Do not show accessories when the user asks for the main product. " +
        "Never invent products or specs. Only use data returned by the tools.\n" +
        "\n" +
        "IMPORTANT: The app already shows the products as visual cards (image, name, price). " +
        "So NEVER list the products again in your text. " +
        "Do not write names or prices one by one.\n" +
        "Instead write a short, natural chat message (2 to 4 sentences) like a helpful friend:\n" +
        "1. One friendly line saying you found options.\n" +
        "2. Your pick: name the one or two best options and say why " +
        "(for example best value, cheapest, highest rating, premium choice).\n" +
        "3. One short question to continue, like asking their budget.\n" +
        "\n" +
        "FORMAT: Plain text only. No markdown, no asterisks, no # headings, no bullet lists.",
    },
    { role: "user", content: userMessage },
  ];

  const foundProducts: Product[] = [];

  // Agent loop: zyada se zyada 5 round
  for (let i = 0; i < 5; i++) {
    const response = await client.chat.completions.create({
      model: MODEL,
      messages,
      tools,
    });

    const msg = response.choices[0].message;
    messages.push(msg);

    // Tool call nahi hai to final jawab mil gaya
    if (!msg.tool_calls || msg.tool_calls.length === 0) {
      return { reply: msg.content ?? "", products: foundProducts };
    }

    // Har tool call chalao aur result LLM ko wapas do
    for (const call of msg.tool_calls) {
      if (call.type !== "function") continue;

      let result: unknown;
      try {
        const args = JSON.parse(call.function.arguments || "{}");
        result = await runTool(call.function.name, args);

        if (Array.isArray(result) && typeof result[0] === "object") {
          foundProducts.push(...(result as Product[]));
        }
      } catch (e) {
        result = { error: "Tool failed" };
      }

      messages.push({
        role: "tool",
        tool_call_id: call.id,
        content: JSON.stringify(result),
      });
    }
  }

  return {
    reply: "Sorry, I could not finish that request.",
    products: foundProducts,
  };
}
