//
//  NewAccountViewController.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 5/4/25.
//
//
import UIKit
import CoreData

class NewAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !username.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            print("All fields must be filled.")
            return
        }

        guard password == confirmPassword else {
            print("Passwords do not match.")
            return
        }

        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }

        let newUser = User(context: context)
        newUser.username = username
        newUser.password = password

        do {
            try context.save()
            print("User saved!")

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
