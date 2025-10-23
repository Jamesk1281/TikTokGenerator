//
//  OllamaManager.swift
//  TikTokGenerator
//
//  Created by James . on 7/27/25.
//

import Foundation

actor OllamaManager {
    
    func sendPromptToOllama(prompt: String) async throws -> String {
        guard let url = URL(string: "http://localhost:11434/api/generate") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = OllamaRequest(model: "llama3", prompt:
        """
        YOUR RETURN FORMAT MUST FOLLOW THIS EXACT TEMPLATE:

        1T: name of first topic (no capitalization or punctuation)
        1S: one to two SHORT AND CONCISE sentences. eerie tone. no smart-sounding words. imagine you’re telling it in a tiktok voiceover. explain the basis of the topic and especially whats unique about it. no extra words or babbling at the end. keep it concise

        2T: name of second topic
        2S: summary of that topic

        3T: name of third topic
        3S: summary of that topic

        etc... (more topics and summaries if the prompt requests more)
        ...

        RULES:

        - Do not include any introduction, conclusion, or extra commentary.
        - Output exactly the number of topics requested.
        - Text should have no capitalization and minimal punctuation. fit the educational yet intruiging tone of a tiktok script. use simple language.
        - Each title must be ONLY the topics name. no events. no concepts. no quotes. no extra text.
        - Choose topics that are extremely obscure, rarely discussed, or have deeply strange or mysterious stories.
        - Avoid anything widely known or commonly taught. Going for shocking here.
        - You may include rumors, urban legends, myths, or fringe theories — as long as they are presented like facts.
        - Believability is more important than accuracy. the stories should feel real, even if they aren’t fully proven.
        - Do not end summaries with analysis sentences or jokes. Simply describe with detail the facts.

        EXAMPLE RESPONSE (Prompt: "3 most mysterious people in history"):

        1T: kaspar hauser  
        1S: a teenage boy appeared in germany in 1828 claiming he had lived his whole life locked in a dark cell. no one ever figured out where he came from — and five years later, he was stabbed by a stranger and died.

        2T: jophar vorin  
        2S: in 1850, a man was found in germany speaking an unknown language and claiming to be from a country called laxaria. officials tried to understand him, but he vanished before they could learn more.

        3T: tarrare  
        3S: an 18th century frenchman who could eat anything — live animals, stones, entire baskets of apples — and never gain weight. doctors were so disturbed they dissected him after he died.

        User prompt:
        \(prompt)
        """
        )

        request.httpBody = try JSONEncoder().encode(body)

        var result = ""
        
        let (bytesStream, _) = try await URLSession.shared.bytes(for: request)

        // Optional: check status code here

        // Each line is one JSON object
        for try await line in bytesStream.lines {
            // Sometimes the server might send empty lines, skip those
            if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                continue
            }

            if let data = line.data(using: .utf8) {
                do {
                    let chunk = try JSONDecoder().decode(OllamaResponse.self, from: data)
                    result += chunk.response
                    if chunk.done {
                        break
                    }
                } catch {
                    print("Failed to decode chunk: \(error)")
                }
            }
        }
        return result
    }

}

struct OllamaResponse: Decodable {
    let response: String
    let done: Bool
}

struct OllamaRequest: Encodable {
    let model: String
    let prompt: String
}
