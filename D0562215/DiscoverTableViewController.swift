//
//  DiscoverTableViewController.swift
//  D0515119
//
//  Created by A-Lye on 12/9/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    var restaurants:[CKRecord] = []
    @IBOutlet var spinner:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecordsFromCloud()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        spinner?.hidesWhenStopped = true
        spinner?.center = view.center
        tableView.addSubview(spinner!)
        spinner?.startAnimating()
    }
    
    func fetchRecordsFromCloud()
    {
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record) -> Void in
            self.restaurants.append(record)
        }
        
        queryOperation.queryCompletionBlock = { (cursor,error) -> Void in
            if let error = error{
                print("Failed to get data from iCloud -\(error.localizedDescription)")
                return
            }
            
            
            print("Successfully retrieve the data from iCloud")
            OperationQueue.main.addOperation{
                self.spinner?.stopAnimating()
                self.tableView.reloadData()
            }
        }
        
        //        publicDatabase.perform(query, inZoneWith: nil, completionHandler: {(results,error) -> Void in
        //            if error != nil{
        //                print(error)
        //                return
        //            }
        //            if let results = results{
        //                print("Completed the download of Restaurant data")
        //                self.restaurants = results
        //                self.tableView.reloadData()
        //            }
        //        })
        
        publicDatabase.add(queryOperation)
    }
    
    override func tableView(_ tableView:UITableView, numberOfRowsInSection numberOfRowsInSectionsection:Int) -> Int{
        return restaurants.count
    }
    var imageCache:NSCache = NSCache<CKRecordID, NSURL>()
    
    override func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.object(forKey: "name") as? String
        cell.imageView?.image = UIImage(named:"photoalbum")
        if let imageFileURL = imageCache.object(forKey: restaurant.recordID) {
            print("img get from cache")
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL){
                cell.imageView?.image = UIImage(data: imageData)
            }
        }
        else {
            let publicDatabase = CKContainer.default().publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.perRecordCompletionBlock = {
                (record,recordID,error) -> Void in
                if let error = error {
                    print("error",error)
                    return
                }
                if let restaurantRecord = record {
                    OperationQueue.main.addOperation {
                        if let image = restaurantRecord.object(forKey: "image"){
                            let imageAsset = image as! CKAsset
                            
                            if let imageData = try?Data.init(contentsOf: imageAsset.fileURL){
                                cell.imageView?.image = UIImage(data: imageData)
                                self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: restaurant.recordID)
                            }
                        }
                    }
                }
            }
            publicDatabase.add(fetchRecordsImageOperation)}
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
