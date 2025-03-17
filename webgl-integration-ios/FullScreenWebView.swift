//
//  FullScreenWebView.swift
//  webgl-integration-ios
//
//  Created by Jairam Surakanti on 3/17/25.
//

import SwiftUI
import WebKit

struct FullScreenWebView: View {
    let urlString: String
    @Binding var showWebView: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            WebView(urlString: urlString, showWebView: $showWebView)
                .ignoresSafeArea() // Ensures full screen with no margins

            // Close button
            Button(action: {
                showWebView = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
                    .padding(.trailing, 20)
                    .padding(.top, 40) // Adjust for top spacing
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
