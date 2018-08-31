//
//  Item.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/11/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import Foundation

class Item: ModelBase, ModelProtocol {
    var cId : String?
    var cProduct : String?
    var cCondition : String?
    var cPrice : String?
    var cSeller : String?
    //var cDate : String?
    
    override func objectMapping() -> Dictionary<String, String>{
        
        let objecMapping = [
            "cId":"_id",
            "cProduct":"product",
            "cCondition":"condition",
            "cPrice":"price",
            "cSeller":"seller"
            //"cDate":"item_date"
        ]
        
        return objecMapping
        
    }

}
