//
//  PlantFlowerViewController.swift
//  Petal
//
//  Created by Jing Xiao on 12/1/14.
//  Copyright (c) 2014 Jing Xiao. All rights reserved.
//

import UIKit

protocol PlantFlowerDelegate {
    func receivedNewFlower(flowerType: String, friend1: String, friend2: String)
}

class PlantFlowerViewController: UIViewController {
    
    var delegate: PlantFlowerDelegate!
    var currentUser: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(currentUser)
        self.errorLabel.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var friendTextField: UITextField!
    @IBOutlet var flower1: UIButton!
    @IBOutlet var flower2: UIButton!
    @IBOutlet var flower3: UIButton!
    
    @IBAction func flower1Button(sender: AnyObject) {
        flower1.selected = !flower1.selected
        
        if (flower1.selected == true) {
            flower2.selected = false
            flower3.selected = false
        }
    }
    
    @IBAction func flower2Button(sender: AnyObject) {
        flower2.selected = !flower2.selected
        
        if (flower2.selected == true) {
            flower1.selected = false
            flower3.selected = false
        }
    }
    
    @IBAction func flower3Button(sender: AnyObject) {
        flower3.selected = !flower3.selected
        
        if (flower3.selected == true) {
            flower2.selected = false
            flower1.selected = false
        }

    }
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func plantButton(sender: AnyObject) {
        if (self.friendTextField.text != "") {
            var friendUser = self.friendTextField.text
            
            var currentUserQuery = PFUser.query()
            currentUserQuery.whereKey("username", equalTo: currentUser)
            var currentPFUser = currentUserQuery.findObjects()[0]
            
            if (friendUser == currentUser) {
                self.errorLabel.text = "You cannot be friends with yourself!"
            } else {
                var query = PFUser.query()
                query.whereKey("username", equalTo: friendUser)
                var friendPFUsers = query.findObjects()
                
                if (friendPFUsers.count <= 0) {
                    self.errorLabel.text = "Your 'friend' does not exist!"
                } else {
                    var friendPFUser = friendPFUsers[0]
                    println("successfully found friend!")
                    
                    if (!flower1.selected && !flower2.selected && !flower3.selected) {
                        self.errorLabel.text = "You must select a flower type!"
                    } else {
                        self.errorLabel.text = ""
                        var flowerType : String = ""
                        
                        if (flower1.selected) {
                            flowerType = "flower1"
                        } else if (flower2.selected) {
                            flowerType = "flower2"
                        } else { //flower3.selected
                            flowerType = "flower3"
                        }
                        
                        self.delegate.receivedNewFlower(flowerType, friend1: currentUser, friend2: friendUser)
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                    
                }
                
            }
           
        } else {
            self.errorLabel.text = "You must enter a friend's username!"
        }

    }
}
