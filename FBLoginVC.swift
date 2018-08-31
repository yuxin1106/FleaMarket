//
//  FBLoginVC.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/13/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit


class FBLoginVC: UIViewController, FBSDKLoginButtonDelegate {

    var loginButton : FBSDKLoginButton!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if (error != nil) {
            errorMessageLabel.text = "\(error)"
            
        } else if(result.token != nil) {
            self.dismiss(animated: true, completion: nil)
            
        } else {
            errorMessageLabel.text = "Unknown error occured"
        }
        
        
        
        print("loginButton didCompleteWith \(error)")
        
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        
    }
    
    @IBAction func backTouched(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postOnFBTouched(_ sender: Any) {
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = URL(string: "http://www.google.com")
        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
