//
//  NewAccountViewController.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 5/4/25.
//

import UIKit
import CoreData

class NewAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              password == confirmPassword else {
            print("passwords don't match")
            return
        }
        
        // Save to Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let newUser = User(context: context)
        newUser.username = username
        newUser.password = password
        
        
        do {
            try context.save()
            print("User saved!")
            // After saving, transition to the FindParking ViewController
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let findParkingVC = storyboard.instantiateViewController(withIdentifier: "FindParkingViewController") as? FindParkingViewController {
                self.navigationController?.pushViewController(findParkingVC, animated: true)
            }
            
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
