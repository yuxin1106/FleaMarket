//
//  NewPostVC.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/11/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import UIKit

class NewItemVC: UIViewController {

    @IBOutlet weak var product: UITextField!
    @IBOutlet weak var condition: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var seller: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }

    
    @IBAction func saveButtonTouched(_ sender: Any) {
        // get and format the current date
       // let dateFormatter = DateFormatter()
       // dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
       // let formatedDate = dateFormatter.string(from: Date())
        
        let item : Item = Item()
        item.cProduct = self.product.text
        item.cCondition = self.condition.text
        item.cPrice = self.price.text
        item.cSeller = self.seller.text
        //item.cDate = formatedDate
        
        PostsManager.createPost(item){
            (success, error) -> Void in
            
            print(success)
            
            self.dismiss(animated: true, completion: nil)

        }
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
