//
//  FavoritesTableViewController.swift
//  FavFlickrPhotos
//
//  Created by Koss on 05/03/16.
//  Copyright © 2016 mine. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {

    var fetchedResultsController: NSFetchedResultsController!
    var imageData = [NSManagedObject]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let managedContext = appDelegate.dataController.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Image")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            imageData = results as! [NSManagedObject]
            //print(imageData)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.imageData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("showImageCell", forIndexPath: indexPath) as! FavoriteImageTableViewCell
        //convert date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        // Configure the cell...
        let favImageData = imageData[indexPath.row]
        let img_url = NSURL(string: favImageData.valueForKey("imageURL") as! String)
        let image = NSData(contentsOfURL: img_url!)
        if image != nil {
            if let imagen = UIImage(data: image!) {
                cell.favImage.image = imagen
            }
        }
        cell.dateLabel.text = "Date added: " + dateFormatter.stringFromDate(favImageData.valueForKey("date") as! NSDate)
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedContext = appDelegate.dataController.managedObjectContext
        if editingStyle == .Delete {
            let itemToDelete = imageData[indexPath.row]
            print(itemToDelete)
            // Delete the row from the data source and context
             managedContext.deleteObject(itemToDelete)
            //self.tableView.reloadData()
            imageData.removeAtIndex(indexPath.row)
            do {
                //after making changes, save has to be called
                try managedContext.save()
            } catch {
                fatalError("couldn't save context")
            }

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showFullImage" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            //let image = ob
            let fullImage = segue.destinationViewController as! FavViewController
            //fullImage.imgTitle = "Hello"
            let favImageData = imageData[indexPath.row]
            let img_url = NSURL(string: favImageData.valueForKey("imageURL") as! String)
            let image = NSData(contentsOfURL: img_url!)
            if image != nil {
                if let imagen = UIImage(data: image!) {
                    fullImage.imageFav = imagen
                }
            }
            fullImage.imgTitle = favImageData.valueForKey("title") as! String

        }
        
    }
    

}
