package com.pharma.service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class AIChatService {
    private static final String API_KEY = "sk-da14be6af09f49359787f8ebb77755d8";
    private static final String API_ENDPOINT = "https://api.deepseek.com/chat/completions";
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public AIChatService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    public String getAIResponse(String userMessage) throws IOException, InterruptedException {
        String requestBody = String.format("""
            {
                "model": "deepseek-chat",
                "messages": [
                    {
                        "role": "system",
                        "content": "你是一个专业的医药助手，可以回答药品相关的问题，提供用药建议，分析处方等。请用专业但易懂的语言回答。"
                    },
                    {
                        "role": "user",
                        "content": "%s"
                    }
                ],
                "temperature": 0.7,
                "max_tokens": 1000
            }
            """, userMessage.replace("\"", "\\\""));

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(API_ENDPOINT))
                .timeout(Duration.ofSeconds(20))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + API_KEY)
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {
            JsonNode root = objectMapper.readTree(response.body());
            JsonNode choices = root.path("choices");
            if (choices.isArray() && !choices.isEmpty()) {
                return choices.get(0).path("message").path("content").asText();
            } else {
                throw new IOException("Response JSON missing choices: " + response.body());
            }
        } else {
            throw new IOException("API request failed: " + response.statusCode() + ", body: " + response.body());
        }
    }
}
