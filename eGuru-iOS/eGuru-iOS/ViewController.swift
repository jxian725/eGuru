//
//  ViewController.swift
//  eGuru-iOS
//
//  Created by UHS TECHNOLOGY on 26/03/2022.
//

import UIKit
import WebKit
import UserNotifications
import GCDWebServer
import Telegraph

class ViewController: UIViewController,WKScriptMessageHandler,UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate {
    
    let webView = WKWebView()
    var newWebviewPopupWindow: WKWebView?
    var webServer = GCDWebServer()
    var identity: CertificateIdentity?
    var caCertificate: Certificate?
    var tlsPolicy: TLSPolicy?
    var server: Server!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        guard let url = URL(string: "http://localhost:3231/index.html") else {
            return
        }
        let contentController = self.webView.configuration.userContentController
        contentController.add(self, name: "iOS")
        webView.uiDelegate = self
        webView.scrollView.bounces = false
        //deleteCache() //Development Cache Clearing
        loadCertificates(url: url)
    }
    
    
    private func loadCertificates(url: URL) {
        if let identityURL = Bundle.main.url(forResource: "localhost", withExtension: "p12") {
            identity = CertificateIdentity(p12URL: identityURL, passphrase: "test")
            print(identity)
        }
        if let caCertificateURL = Bundle.main.url(forResource: "ca", withExtension: "der") {
            caCertificate = Certificate(derURL: caCertificateURL)
            print(caCertificate)
        }
        if let caCertificate = caCertificate {
            tlsPolicy = TLSPolicy(commonName: "localhost", certificates: [caCertificate])
        }
        if let identity = identity, let caCertificate = caCertificate {
            server = Server()
            //server = Server(identity: identity, caCertificates: [caCertificate])
            print("Loaded cert")
        } else {
            server = Server()
        }
        let path = Bundle.main.url(forResource: "webview", withExtension: nil)!
        server.serveDirectory(path)
        do {try server.start(port: 3231, interface: "localhost")}catch{
            print("server active")
        }
        print("[SERVER]", "Server is running - url:", serverURL())
        webView.load(URLRequest(url: url))
    }
    
    private func serverURL(path: String = "") -> URL {
        var components = URLComponents()
        components.scheme = server.isSecure ? "https" : "http"
        components.host = "localhost"
        components.port = Int(server.port)
        components.path = path
        return components.url!
      }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        newWebviewPopupWindow = WKWebView(frame: view.bounds, configuration: configuration)
                newWebviewPopupWindow!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                newWebviewPopupWindow!.navigationDelegate = self
                newWebviewPopupWindow!.uiDelegate = self
                view.addSubview(newWebviewPopupWindow!)

        return newWebviewPopupWindow!
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            guard let serverTrust = challenge.protectionSpace.serverTrust else { return completionHandler(.useCredential, nil) }
            let exceptions = SecTrustCopyExceptions(serverTrust)
            SecTrustSetExceptions(serverTrust, exceptions)
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let body = "\(message.body)"
        var type = "", msg = ""
        if let index = body.range(of: "|") {
            type = "\(body[body.startIndex..<index.lowerBound])"
            msg = "\(body[index.upperBound...])"
        }
        if(message.name == "iOS"){
            if(type == "browser"){
                let URLprotocol = msg[msg.index(msg.startIndex, offsetBy: 0)..<msg.index(msg.startIndex, offsetBy: 4)]
                if(URLprotocol != "http"){
                    msg = "https://\(msg)"
                }
                if let requestUrl = NSURL(string: "\(msg)") {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(requestUrl as URL)
                    } else {
                        UIApplication.shared.openURL(requestUrl as URL)
                    }
                }
            }else if(type == "qrScanner"){
                let vc = storyboard?.instantiateViewController(withIdentifier: "QRScanner") as! QRScannerController
                vc.completionHandler = { text in
                    let result = "\(text ?? "cancel")"
                    if(result == "cancel"){
                        self.callJavascriptFunc(parameter: "window.parent.$('#preloader').css('display','none');")
                        self.showToast(message: "Abort QR Scanner", font: .systemFont(ofSize: 12.0))
                    }else{
                        let callfunction = "qrScannerCallback('\(String(describing: result))');"
                        self.callJavascriptFunc(parameter: callfunction)
                    }
                }
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
        }
    }
    
    func callJavascriptFunc(parameter: String){
        self.webView.evaluateJavaScript("\(parameter)") { result, error in
            guard error == nil else {
                print(error!)
                return
            }
        }
    }
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 25, y: self.view.frame.size.height-100, width: self.view.frame.size.width-50, height: 35))
        toastLabel.numberOfLines = 2
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.2, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        _ = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
            let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
            swipeRightRecognizer.direction = .right
            webView.addGestureRecognizer(swipeRightRecognizer)
    }
    
    @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if (recognizer.direction == .right) {
            if webView.canGoBack {
                self.callJavascriptFunc(parameter: "history.back();")
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        additionalSafeAreaInsets.bottom -= bottomLayoutGuide.length
    }
    
    private func deleteCache(){
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
    }
}
