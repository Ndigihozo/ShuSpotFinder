//
//  LotSelectionViewController.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 5/6/25.
//
import UIKit
import CoreData

class LotSelectionViewController: UIViewController {

    var selectedLot: String?

    @IBAction func LotA(_ sender: UIButton) { selectedLot = "Lot A" }
    @IBAction func LotB(_ sender: UIButton) { selectedLot = "Lot B" }
    @IBAction func LotC(_ sender: UIButton) { selectedLot = "Lot C" }
    @IBAction func LotD(_ sender: UIButton) { selectedLot = "Lot D" }
    @IBAction func LotE(_ sender: UIButton) { selectedLot = "Lot E" }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let lot = selectedLot else {
            print("No lot selected.")
            return
        }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newUsage = LotUsage(context: context)
        newUsage.lotname = lot
        newUsage.action = "selected"
        newUsage.timestamp = Date()
        do {
                try context.save()
                print("Saved usage for \(lot)")
                saveTrendForUser(lot: lot)

                // Go back to FindParkingViewController
                if let nav = navigationController {
                    nav.popViewController(animated: true)
                }
        } catch {
                print("Error saving usage: \(error.localizedDescription)")
            }
        
        }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func navigateBackToFindParking() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func saveTrendForUser(lot: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()

        do {
            let users = try context.fetch(request)
            if let user = users.first {
                user.currentlot = lot
                try context.save()
                print("Current lot set to \(lot)")
            }
        } catch {
            print("Error saving user lot: \(error.localizedDescription)")
        }
    }

    }

