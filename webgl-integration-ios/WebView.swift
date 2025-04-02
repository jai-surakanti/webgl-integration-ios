//
//  WebView.swift
//  webgl-integration-ios
//
//  Created by Jairam Surakanti on 3/17/25.
//


import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String
    @Binding var showWebView: Bool

    func makeCoordinator() -> WebViewCoordinator {
        return WebViewCoordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "actionCompleted")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        context.coordinator.webView = webView // 👈 ADD THIS LINE

        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    static func dismantleUIView(_ uiView: WKWebView, coordinator: WebViewCoordinator) {
        uiView.configuration.userContentController.removeScriptMessageHandler(forName: "actionCompleted")
    }

    class WebViewCoordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView
        weak var webView: WKWebView?

        init(_ parent: WebView) {
            self.parent = parent
            super.init()
            NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }

        @objc func appDidEnterBackground() {
            print("App moved to background — attempting to pause game...")
            webView?.evaluateJavaScript("PauseGame();", completionHandler: { result, error in
                if let error = error {
                    print("JavaScript error: \(error.localizedDescription)")
                } else {
                    print("PauseGame() JS method executed")
                }
            })
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "actionCompleted", let body = message.body as? [String: Any] {
                print("Received message from JavaScript: \(body)")

                if let status = body["status"] as? String,
                   let msg = body["message"] as? String,
                   let data = body["data"] as? [String: Any],
                   let userId = data["userId"],
                   let score = data["score"],
                   let timestamp = data["timestamp"] {

                    print("Status: \(status)")
                    print("Message: \(msg)")
                    print("User ID: \(userId)")
                    print("Score: \(score)")
                    print("Timestamp: \(timestamp)")
                }

                // Dismiss WebView
                DispatchQueue.main.async {
                    self.parent.showWebView = false
                }
            }
        }
    }
}
