const express = require("express");
const app = express();
const port = process.env.PORT || 3000;
const instance = process.env.INSTANCE || "A";

app.get("/", (req, res) => {
  res.send(`Hello from instance ${instance}`);
});

app.listen(port, () => {
  console.log(`Server ${instance} running on port ${port}`);
});
