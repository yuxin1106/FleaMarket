//
//  SMSVC.swift
//  FleaMarket
//
//  Created by Xin Yu on 12/2/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import UIKit
import Alamofire

class SMSVC: UIViewController {

    @IBOutlet weak var message: UITextView!
    // to get the phone number of the picked item
    var pickedItem: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //message.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show keyboard by default
        message.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendSMSTouched(_ sender: Any) {
        // headers for Alamofire request
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        // parameters for Alamofire request
        let parameters: Parameters = [
            "To": pickedItem.cPhone ?? "",
            "Body": message.text ?? ""
        ]
        
        //print(pickedItem.cPhone)
        // need to update the address for python application
        Alamofire.request("http://05c4b807.ngrok.io/sms", method: .post, parameters: parameters, headers: headers).response { response in
            print(response)
            
        }
        
        
    }
    
    
    @IBAction func backTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
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
