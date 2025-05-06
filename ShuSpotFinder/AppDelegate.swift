//
//  AppDelegate.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 4/21/25.
//
import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Check if the URL scheme is spotfinder://
        if url.absoluteString.contains("spotfinder://") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let findParkingVC = storyboard.instantiateViewController(withIdentifier: "FindParkingViewController") as? FindParkingViewController {
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootVC = windowScene.windows.first?.rootViewController {
                        // Navigate to the Lot Selection screen
                        rootVC.present(findParkingVC, animated: true, completion: nil)
                    }
                }
            }
            return true
        }
        return false
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShuSpotFinder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
   
    }
