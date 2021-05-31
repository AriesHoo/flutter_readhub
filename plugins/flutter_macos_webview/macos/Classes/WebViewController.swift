//
//  WebViewController.swift
//  flutter_macos_webview
//
//  Created by vanya elizarov on 22.11.2020.
//

import Cocoa
import FlutterMacOS
import WebKit

class WebViewController: NSViewController {
    enum PresentationStyle: Int {
        case modal = 0
        case sheet = 1
    }
    
    static let closeNotification = Notification.Name("WebViewCloseNotification")
    
    private let webview: WKWebView
    
    private let frame: CGRect
    private let channel: FlutterMethodChannel
    private let presentationStyle: PresentationStyle
    private let modalTitle: String!
    private let sheetCloseButtonTitle: String
    
    var javascriptEnabled: Bool {
        set { webview.configuration.preferences.javaScriptEnabled = newValue }
        get { webview.configuration.preferences.javaScriptEnabled }
    }
    
    var userAgent: String? {
        set {
            if let userAgent = newValue {
                webview.customUserAgent = userAgent //" Custom Agent"
            } else {
                webview.customUserAgent = nil
            }
        }
        get { webview.customUserAgent }
    }
        
    required init(
        channel: FlutterMethodChannel,
        frame: NSRect,
        presentationStyle: PresentationStyle,
        modalTitle: String,
        sheetCloseButtonTitle: String
    ) {
        self.channel = channel
        self.frame = frame
        self.presentationStyle = presentationStyle
        self.modalTitle = modalTitle
        self.sheetCloseButtonTitle = sheetCloseButtonTitle
        
        webview = WKWebView()
        
        super.init(nibName: nil, bundle: nil)
        
        webview.navigationDelegate = self
        webview.uiDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadUrl(url: URL) {
        let req = URLRequest(url: url)
        webview.load(req)
    }
    
    @objc private func closeSheet() {
        self.view.window?.close()
    }
    
    private func setupViews() {
        webview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webview)
        
        var constraints: [NSLayoutConstraint] = [
            webview.topAnchor.constraint(equalTo: view.topAnchor),
            webview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webview.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        if (presentationStyle == .sheet) {
            let bottomBarHeight: CGFloat = 44.0
            constraints.append(
                webview.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -bottomBarHeight)
            )

            let bottomBar = NSView()
            bottomBar.wantsLayer = true
            bottomBar.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
            bottomBar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bottomBar)
            
            constraints.append(contentsOf: [
                bottomBar.topAnchor.constraint(equalTo: webview.bottomAnchor),
                bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomBar.heightAnchor.constraint(equalToConstant: bottomBarHeight),
            ])
            
            let closeButton = NSButton()
            closeButton.isBordered = false
            closeButton.title = sheetCloseButtonTitle
            closeButton.font = NSFont.systemFont(ofSize: 14.0)
            //closeButton.contentTintColor = .systemBlue
            closeButton.bezelStyle = .rounded
            closeButton.setButtonType(.momentaryChange)
            closeButton.sizeToFit()
            closeButton.target = self
            closeButton.action = #selector(self.closeSheet)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            bottomBar.addSubview(closeButton)

            constraints.append(contentsOf: [
                closeButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor),
                closeButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
                closeButton.widthAnchor.constraint(equalToConstant: closeButton.frame.width + 20.0),
                closeButton.heightAnchor.constraint(equalTo: bottomBar.heightAnchor)
            ])
        } else {
            title = modalTitle
            constraints.append(webview.heightAnchor.constraint(equalTo: view.heightAnchor))
        }

        constraints.forEach { (c) in
            c.isActive = true
        }
    }
    
    override func loadView() {
        view = NSView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    override func viewDidAppear() {
        view.window?.delegate = self
    }
}

extension WebViewController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NotificationCenter.default.post(name: WebViewController.closeNotification, object: nil)
    }
}

extension WebViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let isMainFrame = navigationAction.targetFrame?.isMainFrame else { return nil }
        if !isMainFrame {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url?.absoluteString else { return }
        channel.invokeMethod("onPageStarted", arguments: [ "url": url ])
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url?.absoluteString else { return }
        channel.invokeMethod("onPageFinished", arguments: [ "url": url ])
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        let error = NSError(
            domain: WKError.errorDomain,
            code: WKError.webContentProcessTerminated.rawValue,
            userInfo: nil
        )
        onWebResourceError(error)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onWebResourceError(error as NSError)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        onWebResourceError(error as NSError)
    }
    
    static func errorCodeToString(code: Int) -> String? {
        switch code {
            case WKError.unknown.rawValue:
                return "unknown";
            case WKError.webContentProcessTerminated.rawValue:
                return "webContentProcessTerminated";
            case WKError.webViewInvalidated.rawValue:
                return "webViewInvalidated";
            case WKError.javaScriptExceptionOccurred.rawValue:
                return "javaScriptExceptionOccurred";
            case WKError.javaScriptResultTypeIsUnsupported.rawValue:
                return "javaScriptResultTypeIsUnsupported";
            default:
                return nil;
        }
        
    }
    
    func onWebResourceError(_ error: NSError) {
        channel.invokeMethod("onWebResourceError", arguments: [
            "errorCode": error.code,
            "domain": error.domain,
            "description": error.description,
            "errorType": WebViewController.errorCodeToString(code: error.code) as Any
        ])
    }
}

extension NSImage {
    func tint(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()

        color.set()

        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()

        return image
    }
}
