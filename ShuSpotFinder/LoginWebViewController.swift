import UIKit
import WebKit

class LoginWebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setupWebView()
        loadLoginPage()
        
    }

    private func setupWebView() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView.navigationDelegate = self
        view.addSubview(webView)
    }

    private func loadLoginPage() {
        if let url = URL(string: "https://my.setonhill.edu") {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            print("Invalid login URL")
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let currentURL = webView.url?.absoluteString else { return }
        print("Finished loading: \(currentURL)")

        if currentURL.contains("/home") || currentURL.contains("/dashboard") {
            navigateToFindParking()
        }
    }

    func navigateToFindParking() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let findParkingVC = storyboard.instantiateViewController(withIdentifier: "FindParkingViewController") as? FindParkingViewController {
                self.navigationController?.pushViewController(findParkingVC, animated: true)
            }
        }
    }
}
