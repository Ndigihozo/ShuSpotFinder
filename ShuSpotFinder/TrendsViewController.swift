//
//  TrendsViewController.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 5/6/25.
////
//  TrendsViewController.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 5/6/25.
//

import UIKit
import CoreData

class TrendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var lotTrends: [(lot: String, count: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchLotTrends()
    }
    
    func fetchLotTrends() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LotUsage> = LotUsage.fetchRequest()
        
        do {
            let usages = try context.fetch(fetchRequest)
            
            var trendDict: [String: Int] = [:]
            for usage in usages {
                let lot = usage.lotname ?? "Unknown"
                trendDict[lot, default: 0] += 1
            }
            
            // Sort by most crowded to least
            lotTrends = trendDict.sorted { $0.value > $1.value }
                                  .map { (lot: $0.key, count: $0.value) }

            tableView.reloadData()
            
            if let leastCrowded = lotTrends.last {
                print("Suggested lot: \(leastCrowded.lot) - only \(leastCrowded.count) users")
            }
        } catch {
            print("Failed to fetch trends: \(error.localizedDescription)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lotTrends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendCell", for: indexPath)
        let lot = lotTrends[indexPath.row]
        cell.textLabel?.text = "\(lot.lot): \(lot.count) check-ins"
        return cell
    }
}
