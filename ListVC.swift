//
//  ViewController.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/10/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import UIKit

class ListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var itemTable: UITableView!
    
    fileprivate var items : Array<Item>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //reloadTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
   
     // Background task ??
    
    func reloadTableView(){
        
        PostsManager.readPostsWithHandler{
            (items : Array<Item>?, error: AnyObject?) in
            
            self.items = items
            
            DispatchQueue.main.async(
                execute: {
                    () -> Void in
                    
                    var bTask : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
                    bTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                        UIApplication.shared.endBackgroundTask(bTask)
                        bTask  = UIBackgroundTaskInvalid
                        print("expirationHandler Termination")
                        
                    })
                    
                    self.itemTable.reloadData()
                    
                    UIApplication.shared.endBackgroundTask(bTask)
                    bTask  = UIBackgroundTaskInvalid
                    
                    print("Background Done")
                    
            })
            
            
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = items{
            return items.count
            //print(items.count)
        }
        return 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell : ItemTVC = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTVC
        
        let item : Item = self.items[(indexPath as NSIndexPath).row]

        cell.productLabel?.text = item.cProduct
        cell.sellerLabel?.text = item.cSeller
        cell.conditionLabel?.text = item.cCondition
        cell.priceLabel?.text = item.cPrice
        
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCellEditingStyle.delete{
            self.deleteMessageAtIndex(mIndex: indexPath.row)
        }
    }
    
    
    func deleteMessageAtIndex(mIndex: Int){
        //let resourceId = String(describing: self.items[mIndex].cId)
        //print("\(resourceId)")
        let resourceId = self.items[mIndex].cId
        
        PostsManager.deletePost(resourceId!){(success, error) -> Void in
            DispatchQueue.main.sync {
                print(success)
                self.items.remove(at: mIndex)
                print(mIndex)
                let indexPath = IndexPath(row: mIndex, section: 0)
                self.itemTable.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                self.itemTable.reloadData()
            }
            
        }
    }
    


}







