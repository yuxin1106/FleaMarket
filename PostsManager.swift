//
//  PostsManager.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/11/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import Foundation

class PostsManager: ManagerBase {

    class func readPostsWithHandler(_ callback:@escaping (_ posts : Array<Item>?, _ error: AnyObject?)->()){
        
        ServerAPIManager.sharedInstance.readResource(ServerAPIManager.Resources.Items){
            (data, error) -> () in
            
            if error != nil{
                callback(nil, error)
                
            }else{
                var items : Array<Item> =  [Item]()
                
                //var i = 0;
                
                if let things = data as? Array<NSDictionary> {
                    for thing in things{
                        let item : Item = Item()
                        item.fromDictionary(thing as! Dictionary<String, AnyObject>)
                        items.append(item)
                       // print("\(i)")
                       // i = i+1
                    }
                }
                print(items.count)
                callback(items, nil)
            }
        }
        
        
    }
    
    
    class func createPost(_ post : Item, withHandler callback: @escaping (_ success : Bool, _ error: AnyObject?) -> Void){
        
        let postData = post.toDictionary()
        
        ServerAPIManager.sharedInstance.createResource(ServerAPIManager.Resources.Items, data: postData){
            (data, error) -> () in
            
            if error != nil{
                
                callback(false, error)
                
            }else{
                
                callback(true, nil)
            }

        }
        
        
    }
    
    
    
    class func deletePost(_ postId : String, withHandler callback: @escaping (_ success : Bool, _ error: AnyObject?) -> Void){
        
        ServerAPIManager.sharedInstance.delete(ServerAPIManager.Resources.Items, resourceId: postId){
            (data, error) -> () in
            
            if error != nil{
                
                callback(false, error)
                
            }else{
                
                callback(true, nil)
                
            }
            
            
        }
    }
    
    
    
    
    
}
