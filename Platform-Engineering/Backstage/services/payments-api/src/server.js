"use strict";

const http = require("node:http");
const { randomUUID } = require("node:crypto");

const port = Number.parseInt(process.env.PORT ?? "3000", 10);
const server = http.createServer((request, response) => {
  response.setHeader("content-type", "application/json");
  if (request.method === "GET" && request.url === "/health") {
    response.writeHead(200);
    response.end(JSON.stringify({ service: "payments-api", status: "healthy" }));
    return;
  }
  if (request.method === "POST" && request.url === "/payments") {
    let body = "";
    request.on("data", (chunk) => {
      body += chunk;
    });
    request.on("end", () => {
      response.writeHead(201);
      response.end(
        JSON.stringify({ id: randomUUID(), received: JSON.parse(body) }),
      );
    });
    return;
  }
  response.writeHead(404);
  response.end(JSON.stringify({ error: "not found" }));
});

server.listen(port, "0.0.0.0", () => {
  console.log(`payments-api listening on ${port}`);
});
