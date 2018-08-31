//
//  ModelBase.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/11/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import Foundation


protocol ModelProtocol {
    
    func objectMapping() -> Dictionary<String, String>
    
}

class ModelBase: NSObject {
    var product : String?
    var condition : String?
    var price : String?
    var seller : String?
    
    // override from subclass
    func objectMapping() -> Dictionary<String, String>{
        let objectMapping = Dictionary<String, String>()
        return objectMapping
    }
    
    
    func fromDictionary(_ dict: Dictionary<String, AnyObject>, withRootNode rootNode: String){
        
        let propertyBag = dict[rootNode] as! Dictionary<String, AnyObject>
        fromDictionary(propertyBag)
    }

    
    func fromDictionary(_ dict : Dictionary<String, AnyObject>){
        
        // loop through each one of the mappings
        for (objectKey, jsonKey)  in self.objectMapping() {
            
            // set the value
            let jsonValue = dict[jsonKey]
            
            // if it's NSNull type then just skip it
            if(jsonValue is NSNull){
                continue
            }
            
            self.setValue(dict[jsonKey], forKey: objectKey)
            
        }
        
    }
    
    
    func toDictionary(withRootNode rootNode: String) -> Dictionary<String, AnyObject>{
        
        let propertyBag = toDictionary()
        
        return [rootNode: propertyBag as AnyObject]
        
    }
    
    
    func toDictionary() -> Dictionary<String, AnyObject>{
        
        var dictionary = Dictionary<String, AnyObject>()
        
        // loop through each one of the mappings
        for (objectKey, jsonKey)  in self.objectMapping() {
            
            // set the value
            let objValue = self.value(forKey: objectKey)
            
            // if it's NSNull type then just skip it
            if(objValue is NSNull){
                continue
            }
            
            dictionary[jsonKey] = objValue as AnyObject?
            
        }
        
        return dictionary
        
    }

    
   
    

}
