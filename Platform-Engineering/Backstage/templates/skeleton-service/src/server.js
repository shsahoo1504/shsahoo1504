"use strict";

const http = require("node:http");

const port = Number.parseInt(process.env.PORT ?? "3000", 10);
const server = http.createServer((request, response) => {
  response.setHeader("content-type", "application/json");
  if (request.method === "GET" && request.url === "/health") {
    response.writeHead(200);
    response.end(
      JSON.stringify({ service: "${{ values.name }}", status: "healthy" }),
    );
    return;
  }
  response.writeHead(404);
  response.end(JSON.stringify({ error: "not found" }));
});

server.listen(port, "0.0.0.0", () => {
  console.log("${{ values.name }} listening on " + port);
});
