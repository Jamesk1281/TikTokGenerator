//
//  DiffusionManager.swift
//  TikTokGenerator
//
//  Created by James . on 7/28/25.
//

import Foundation
import SwiftUI

actor DiffusionManager {
    func generateAIImage(prompt: String) async throws -> URL {
        guard let url = URL(string: "http://127.0.0.1:7860/sdapi/v1/txt2img") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "prompt": prompt,
            "steps": 20,
            "sampler_name": "DPM++ 2M Karras",  // ✅ Faster sampler with great quality
            "width": 512,
            "height": 512,
            "batch_size": 1,                    // Optional: more = faster per image
            "enable_hr": false,                 // No high-res fix
            "tiling": false                     // Disable tiling unless needed
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "HTTPError", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Request failed: \(message)"])
        }

        guard let result = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let images = result["images"] as? [String],
              let base64String = images.first,
              let imageData = Data(base64Encoded: base64String) else {
            throw URLError(.cannotParseResponse)
        }

        let filename = UUID().uuidString + ".png"
        let saveDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("GeneratedImages")

        try FileManager.default.createDirectory(at: saveDir, withIntermediateDirectories: true)
        let fileURL = saveDir.appendingPathComponent(filename)
        try imageData.write(to: fileURL)

        return fileURL
    }
}
