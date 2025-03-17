//
//  ContentView.swift
//  webgl-integration-ios
//
//  Created by Jairam Surakanti on 3/17/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showWebView = false

    var body: some View {
        VStack {
            Button("Play FlappyBird") {
                showWebView = true
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showWebView) {
            FullScreenWebView(urlString: "http://localhost:3000/", showWebView: $showWebView)
        }
    }
}
