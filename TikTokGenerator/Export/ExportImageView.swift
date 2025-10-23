//
//  ExportImageView.swift
//  TikTokGenerator
//
//  Created by James . on 7/29/25.
//

import Foundation
import SwiftUI

struct ExportImageView: View {
    let image: NSImage
    let topic: String
    let summary: String
    let topicOffset: CGSize
    let summaryOffset: CGSize

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(nsImage: image)
                .resizable()
                .aspectRatio(9/16, contentMode: .fit)

            Text(topic)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(6)
                .background(Color.black.opacity(0.6))
                .cornerRadius(5)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: 200, alignment: .leading)
                .offset(topicOffset)

            Text(summary)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .padding(6)
                .background(Color.black.opacity(0.6))
                .cornerRadius(5)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: 220, alignment: .leading)
                .offset(summaryOffset)
        }
        .frame(width: 393, height: 700)
    }
}
