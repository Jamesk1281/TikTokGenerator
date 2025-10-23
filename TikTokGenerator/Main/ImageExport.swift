//
//  ViewExt.swift
//  TikTokGenerator
//
//  Created by James . on 7/29/25.
//

import AppKit
import SwiftUI

extension View {
    func snapshotMac(size: CGSize, scale: CGFloat = 2.0) -> NSImage {
        let hostingView = NSHostingView(rootView: self)
        hostingView.frame = CGRect(origin: .zero, size: size)

        let rep = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds)!
        hostingView.cacheDisplay(in: hostingView.bounds, to: rep)

        let image = NSImage(size: size)
        image.addRepresentation(rep)
        return image
    }
}

func saveExportedImagesMac(vm: GeneratorViewModel) {
    let desktop = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("Desktop", isDirectory: true)
    
    let baseFolder = desktop.appendingPathComponent("TikToks", isDirectory: true)

    let sanitizedPrompt = vm.prompt
        .replacingOccurrences(of: "[^a-zA-Z0-9_ -]", with: "", options: .regularExpression)
        .replacingOccurrences(of: " ", with: "_")

    let promptFolder = baseFolder.appendingPathComponent(sanitizedPrompt, isDirectory: true)

    do {
        try FileManager.default.createDirectory(at: promptFolder, withIntermediateDirectories: true)
    } catch {
        print("❌ Could not create folder:", error)
        return
    }

    for index in vm.results.indices {
        let view = ExportImageView(result: vm.results[index],
                                   topicOffset: vm.topicOffsets[index],
                                   summaryOffset: vm.summaryOffsets[index])

        let nsImage = view.snapshotMac(size: CGSize(width: 393, height: 700))

        guard let tiffData = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let jpgData = bitmap.representation(using: .jpeg, properties: [:]) else {
            print("❌ Failed to generate image data for index \(index)")
            continue
        }

        let fileURL = promptFolder.appendingPathComponent("image_\(index).jpg")

        do {
            try jpgData.write(to: fileURL)
            print("✅ Saved to: \(fileURL.path)")
        } catch {
            print("❌ Error saving image \(index):", error)
        }
    }
}
