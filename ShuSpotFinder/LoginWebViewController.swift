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
    
    func setupWebView() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    func loadLoginPage() {
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
        
        // Check if user has reached the dashboard/home
        if currentURL.contains("/home") || currentURL.contains("/dashboard") {
            navigateToFindParking()
        }
    }
    
    func navigateToFindParking() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let findParkingVC = storyboard.instantiateViewController(withIdentifier: "FindParkingViewController") as? FindParkingViewController {
                if let nav = self.navigationController {
                    nav.pushViewController(findParkingVC, animated: true)
                } else {
                    self.present(findParkingVC, animated: true, completion: nil)
                }
            } else {
                print("Failed to load FindParkingViewController")
            }
        }
    }
}
