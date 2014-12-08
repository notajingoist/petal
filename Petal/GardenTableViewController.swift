//
//  GardenTableViewController.swift
//  Petal
//
//  Created by Jing Xiao on 12/7/14.
//  Copyright (c) 2014 Jing Xiao. All rights reserved.
//

import UIKit

struct Flower {
    var flowerType: String
    var friend1: String
    var friend2: String
}

class GardenTableViewController: UITableViewController, PlantFlowerDelegate {
    var currentUser: String!
    var flowers: [Flower] = []
    var soilImage : UIImage! = UIImage(named: "soil")
    var flower1Image : UIImage! = UIImage(named: "flower1")
    var flower2Image : UIImage! = UIImage(named: "flower2")
    var flower3Image : UIImage! = UIImage(named: "flower3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var flowerQuery = PFQuery(className: "Flower")
        flowerQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    var friend1: String = object.objectForKey("friend1") as String
                    var friend2: String = object.objectForKey("friend2") as String
                    if (self.currentUser == friend1 || self.currentUser == friend2) {
                        var flowerType = object.objectForKey("flowerType") as String
                        var newFlower: Flower = Flower(flowerType: flowerType, friend1: friend1, friend2: friend2)
                        self.flowers.append(newFlower)
                    }
                }
                self.tableView.reloadData()
                
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    func receivedNewFlower(flowerType: String, friend1: String, friend2: String) {
        var newFlower = PFObject(className:"Flower")
        newFlower["flowerType"] = flowerType
        newFlower["friend1"] = friend1 //currentUser
        newFlower["friend2"] = friend2 //friendUser
        newFlower.saveInBackgroundWithTarget(nil, selector: nil)
        
        flowers.append(Flower(flowerType: flowerType, friend1: friend1, friend2: friend2))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return self.flowers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("flower", forIndexPath: indexPath) as GardenTableViewCell
        
        var flower = self.flowers[indexPath.row]
        var flowerType = flower.flowerType
        var friendName = (currentUser == flower.friend1) ? flower.friend2 : flower.friend1
        
        cell.friendName.text = friendName
        
        var flowerImage : UIImage! = nil
        if (flowerType == "flower1") {
            flowerImage = self.flower1Image
        } else if (flowerType == "flower2") {
            flowerImage = self.flower2Image
        } else if (flowerType == "flower3") {
            flowerImage = self.flower3Image
        }
        
        cell.flowerButton.selected = true
        cell.flowerButton.setImage(flowerImage, forState: UIControlState.Normal)
        cell.flowerButton.setTitle(flowerType, forState: UIControlState.Normal)
        
        return cell
    }
    
    @IBAction func showFlowerButton(sender: AnyObject) {
        if (sender.currentTitle == "flower1") {
            self.performSegueWithIdentifier("flower1Segue", sender: self)
        } else if (sender.currentTitle == "flower2") {
            self.performSegueWithIdentifier("flower2Segue", sender: self)
        } else if (sender.currentTitle == "flower3") {
            self.performSegueWithIdentifier("flower3Segue", sender: self)
        } else {
            println("flower type title not recognized?")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "plantFlowerSegue":
                var secondViewController = segue.destinationViewController as? PlantFlowerViewController
                secondViewController?.delegate = self
                secondViewController?.currentUser = self.currentUser
            default:
                break
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
