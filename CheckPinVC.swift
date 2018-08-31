//
//  CheckPinVC.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/28/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import UIKit
import KeychainItemWrapper

class CheckPinVC: UIViewController {

    @IBOutlet weak var pinTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func enterButtonTouched(_ sender: AnyObject) {
        
        let keychainItem : KeychainItemWrapper = KeychainItemWrapper(identifier: pinKey, accessGroup: nil)
        
        if let keyValue = keychainItem.object(forKey: kSecValueData as String) as? String{
            
            if (keyValue == pinTF.text){
                dismiss(animated: true, completion: nil)
                pinCheckVC = nil
                isLoggedIn = true
                return
            }
            
        }
        
        // if we got here then something went wrong
        errorLabel.text = "Re-enter Pin"
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
