//
//  WebView.swift
//  feathers
//
//  Created by Drew Larsen on 5/30/25.
//


import SwiftUI
import WebKit

/// A UIViewRepresentable that wraps WKWebView for SwiftUI
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // If the webView’s URL is already what we want, do nothing
        if webView.url != url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
