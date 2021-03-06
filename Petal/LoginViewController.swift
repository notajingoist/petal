//
//  LoginViewController.swift
//  Petal
//
//  Created by Jing Xiao on 11/30/14.
//  Copyright (c) 2014 Jing Xiao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageLabel.text = ""
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        if usernameTextField.text != "" && passwordTextField != "" {
            PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text) {
                (user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    //user exists!
                    self.performSegueWithIdentifier("loggedInSegue", sender: self)
                    
                } else {
                    //sign up instead
                    self.userSignup()
                }
            }
        } else {
            self.messageLabel.text = "All Fields Required"
        }
    }
    
    func userSignup() {
        var user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if (error == nil) {
                self.performSegueWithIdentifier("loggedInSegue", sender: self)
            } else {
                self.messageLabel.text = "Error Signing Up"
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        switch segue.identifier! {
            case "loggedInSegue":
                var secondViewController = segue.destinationViewController as? GardenTableViewController
                secondViewController?.currentUser = self.usernameTextField.text
            
            default:
                break
        }
    }

}
    