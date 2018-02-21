//
//  ViewController.swift
//  EzWebView
//
//  Created by tek4fun on 2/21/18.
//  Copyright © 2018 tek4fun. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController{
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    var loadingView: UIView!
    var actInd: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView = UIView()
        actInd = UIActivityIndicatorView()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        urlField.delegate = self
        urlField.returnKeyType = .done
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    @IBAction func backAction(_ sender: Any) {
        self.webView.goBack()
    }
    
    @IBAction func forwardAction(_ sender: Any) {
        self.webView.goForward()
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        self.webView.reload()
    }
    
    //MARK: Show/Hide Indicator
    func showActivityIndicator(uiView: UIView) {
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColorFromHex(0x444444, 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle = .whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        uiView.addSubview(loadingView)
        actInd.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        actInd.stopAnimating()
        loadingView.removeFromSuperview()
    }
    
    func UIColorFromHex(_ rgbValue:UInt32, _ alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}

//MARK: WebView's Delegate
extension ViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let stringURL = webView.url?.absoluteString
        urlField.text = stringURL
        //showAlert(stringURL!)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(uiView: webView)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideActivityIndicator(uiView: webView)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webView.reload()
    }
    
}

//MARK: TextField's Delegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var url: URL
        if textField.text!.contains("www.") {
            var splitedString = textField.text!.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
            url = URL(string: "http://www." + splitedString[1])!
        } else {
            url = URL(string: "http://www." + textField.text!)!
        }
        webView.load(URLRequest(url: url))
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
}

