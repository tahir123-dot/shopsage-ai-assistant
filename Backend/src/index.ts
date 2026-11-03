import "dotenv/config";
import express from "express";
import cors from "cors";
import { runAgent } from "./agent";

const app = express();
app.use(cors());
app.use(express.json());

app.post("/chat", async (req, res) => {
  const message = req.body?.message;

  if (typeof message !== "string" || message.trim() === "") {
    return res.status(400).json({ error: "message is required" });
  }

  try {
    const result = await runAgent(message.trim());
    res.json(result); // { reply: "...", products: [...] }
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "Something went wrong" });
  }
});

const port = Number(process.env.PORT ?? 3000);
app.listen(port, () => console.log(`Server running on http://localhost:${port}`));