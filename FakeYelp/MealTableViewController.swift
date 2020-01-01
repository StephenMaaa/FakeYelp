//
//  MealTableViewController.swift
//  FakeYelp
//
//  Created by Stephen Ma on 12/29/19.
//  Copyright © 2019 Stephen Ma. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {

    //MARK: Properties
    var mealList = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
        
        if let loadedMeals = load() {
            mealList += loadedMeals
        } else {
            loadMeals()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mealList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = mealList[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.image
        cell.ratingControl.rating = meal.rating
        
        return cell
    }

    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        guard let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal else {
            return
        }
        if let index = tableView.indexPathForSelectedRow {
            mealList[index.row] = meal
            tableView.reloadRows(at: [index], with: UITableView.RowAnimation.automatic)
        } else {
            let newIndexPath = IndexPath(row: mealList.count, section: 0)
            mealList.append(meal)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        saveMeals()
    }
    
    //MARK: Private Methods
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mealList, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func load() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
    private func loadMeals() {
        //load photos
        let image1 = UIImage(named: "meal1")
        let image2 = UIImage(named: "meal2")
        let image3 = UIImage(named: "meal3")
        
        //load meals
        guard let meal1 = Meal.init(name: "Caprese Salad", rating: 4, image: image1) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let meal2 = Meal.init(name: "Chicken and Potatoes", rating: 5, image: image2) else {
            fatalError("Unable to instantiate meal2")
        }
        guard let meal3 = Meal.init(name: "Pasta with Meatballs", rating: 3, image: image3) else {
            fatalError("Unable to instantiate meal3")
        }
        
        //add to the list
        mealList += [meal1, meal2, meal3]
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            mealList.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let destinationController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let index = tableView.indexPath(for: selectedCell) else {
                fatalError("Unexpected index")
            }
            let meal = mealList[index.row]
            destinationController.meal = meal
        default:
            fatalError("Unexpected Segue Identifer: \(segue.identifier)")
        }
    }
    

}
