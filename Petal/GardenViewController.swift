//
//  GardenViewController.swift
//  Petal
//
//  Created by Jing Xiao on 12/1/14.
//  Copyright (c) 2014 Jing Xiao. All rights reserved.
//

import UIKit

class GardenViewController: UIViewController {
    
    
    var currentUser: String!
    var soilImage : UIImage! = UIImage(named: "soil")
    var flower1Image : UIImage! = UIImage(named: "flower1")
    var flower2Image : UIImage! = UIImage(named: "flower2")
    var flower3Image : UIImage! = UIImage(named: "flower3")
    
    var gardenPatch1FlowerType : String!
    var gardenPatch2FlowerType : String!
    var gardenPatch3FlowerType : String!
    var gardenPatch4FlowerType : String!
    
    var gardenPatches : [String: String] = [ "gardenPatch1": "soil", "gardenPatch2": "soil" ]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentUserQuery = PFUser.query()
        currentUserQuery.whereKey("username", equalTo: currentUser)
        var users = currentUserQuery.findObjects()
        
        if (users.count > 0) {
            var currentPFUser = users[0] as PFUser
            if (currentPFUser["flowers"] != nil) {
                var flowers = currentPFUser["flowers"] as NSArray
                
                for (var i = 0; i < flowers.count; i++) {
                    
                    var flowerId : String = flowers[i] as String
                    
                    var query = PFQuery(className: "Flower")
                    query.getObjectInBackgroundWithId(flowerId) {
                        (flowerPFObject: PFObject!, error: NSError!) -> Void in
                            if error == nil {
                                var flowerType = flowerPFObject["flowerType"] as String
//                                var gardenPatchName : String = "gardenPatch" + String(i)
                                var gardenPatchName = flowerPFObject["gardenPatch"] as String
                                println(gardenPatchName)
                                self.gardenPatches[gardenPatchName] = flowerType
                    
                                var flowerImage : UIImage! = nil
                                if (flowerType == "flower1") {
                                    flowerImage = self.flower1Image
                                } else if (flowerType == "flower2") {
                                    flowerImage = self.flower2Image
                                } else if (flowerType == "flower3") {
                                    flowerImage = self.flower3Image
                                }
                    
                                switch gardenPatchName {
                                case "gardenPatch1":
                                    self.soilButton1.selected = true
                                    self.soilButton1.setImage(flowerImage, forState: UIControlState.Normal)
                                case "gardenPatch2":
                                    self.soilButton2.selected = true
                                    self.soilButton2.setImage(flowerImage, forState: UIControlState.Normal)
                                default:
                                    break
                                }
                            } else {
                                println("error getting flower")
                            }
                        }
                }

            }
        
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receivedNewFlower(flowerType: String, friendUsername: String, gardenPatch: String, flowerId: String) {
//        println(flowerType)
//        println(friendUsername)
//        println(gardenPatch)
//        println(flowerId)
        
        gardenPatches[gardenPatch] = flowerType
        
        var flowerImage : UIImage! = nil
        if (flowerType == "flower1") {
            flowerImage = flower1Image
        } else if (flowerType == "flower2") {
            flowerImage = flower2Image
        } else if (flowerType == "flower3") {
            flowerImage = flower3Image
        }
        
        switch gardenPatch {
        case "gardenPatch1":
//            println("gardenPatch1 switch case")
            self.soilButton1.selected = true
            self.soilButton1.setImage(flowerImage, forState: UIControlState.Normal)
        case "gardenPatch2":
            self.soilButton2.selected = true
            self.soilButton2.setImage(flowerImage, forState: UIControlState.Normal)
        default:
            break
        }
        
    }
    
    @IBAction func swipeGarden(sender: UISwipeGestureRecognizer) {
        println("swiped!!")
    }
    
    @IBOutlet var soilButton1: UIButton!
    
    @IBOutlet var soilButton2: UIButton!
    
    @IBAction func soilButton2(sender: AnyObject) {
        //println(soilButton2.titleLabel!.text)
//        var plantFlowerSegue =
//        if (!soilButton2.selected) {
//            self.prepareForSegue("plantFlowerSegue", sender: self)
//        } else {
//            println("already planted flower here")
//        }
        
    }
    
    @IBAction func soilButton1(sender: AnyObject) {
       //self.navigationController?.popToRootViewControllerAnimated(true)
        //self.performSegueWithIdentifier("plantFlowerSegue", sender: self)
        //println(soilButton1.titleLabel!.text)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
//        if let btn = sender as? UIButton {
//            if (identifier! == "plantFlowerSegue") {
//                if (btn.selected) {
//                    return false
//                } else {
//                    return true
//                }
//            } else if (identifier! == "showFlowerSegue") {
//                if (btn.selected) {
//                    return true
//                } else {
//                    return false
//                }
//            }
//        }
        
        
        
        
        if (identifier! == "plantFlowerSegue") {
            if let btn = sender as? UIButton {
                if (btn.selected) {
                    //return false
                    var gardenPatchName = btn.titleLabel!.text
                    if (gardenPatchName != nil) {
                        var segueName = self.gardenPatches[gardenPatchName!]
                        self.performSegueWithIdentifier(segueName! + "Segue", sender: self)
                        
                    } else {
                        println("Doesn't exist for some reason...")
                    }
                    //self.performSegueWithIdentifier("flower1Segue", sender: self)
                    
                    return false
                }
            }
        }
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        switch segue.identifier! {
        case "plantFlowerSegue":
            var secondViewController = segue.destinationViewController as? PlantFlowerViewController
//            secondViewController?.delegate = self
            secondViewController?.currentUser = self.currentUser
            
//            if let btn = sender as? UIButton {
//                secondViewController?.gardenPatch = btn.titleLabel!.text
//                
//                secondViewController?.shouldShow = btn.selected
//                
//            }
            
            
        default:
            break
        }
    }
    

}
