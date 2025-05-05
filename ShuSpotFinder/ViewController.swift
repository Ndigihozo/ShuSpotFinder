// ViewController.swift
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
 
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let loginVC = LoginWebViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
    
