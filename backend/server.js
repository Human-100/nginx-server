const express = require("express");
const cors = require("cors");
const app = express();
const PORT = 3000;

// Middleware to parse JSON requests
app.use(express.json());

// Enable CORS for requests from http://nouman.com
app.use(cors({ origin: "http://nouman.com" }));

// API Endpoint
app.get("/api", (req, res) => {
  res.json({ message: "Hello Nouman!, This is from the internal API hosted on the same VM" });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Backend running on http://localhost:${PORT}`);
});
