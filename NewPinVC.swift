//
//  NewPinVC.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/28/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import UIKit
import KeychainItemWrapper

class NewPinVC: UIViewController {

    @IBOutlet weak var enterPinTF: UITextField!
    @IBOutlet weak var reenterPinTF: UITextField!
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
        
        if(enterPinTF.text != reenterPinTF.text){
            errorLabel.text = "Pins don't match!"
            return
        }
        let keychainItem : KeychainItemWrapper = KeychainItemWrapper(identifier: pinKey, accessGroup: nil)
        
        keychainItem.setObject(pinKey, forKey: kSecAttrAccount)
        
        keychainItem.setObject(kSecAttrAccessibleWhenUnlocked, forKey: kSecAttrAccessible)
        
        keychainItem.setObject(enterPinTF.text, forKey: kSecValueData as String)
        
        pinCheckVC = nil
        
        dismiss(animated: true, completion: nil)

        
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
