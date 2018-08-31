//
//  ServerAPIManager.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/11/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import Foundation

class ServerAPIManager: ManagerBase {
    
    static var instance : ServerAPIManager!

    let baseUrl = "http://fleamarket.site.swiftengine.net/"
    
    enum Resources : String {
        case Items = "items.ssp"
    }
    
    
    func urlSession() -> URLSession{
        return URLSession.shared
    }
    
    
    static let sharedInstance = ServerAPIManager()
    
    
    func readResource(_ resource : Resources, callback:@escaping (_ data : AnyObject?, _ error: AnyObject?)->()) -> Void{
        
        var request : URLRequest = URLRequest(url: URL(string: "\(baseUrl)\(resource.rawValue)")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
       // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = urlSession() //URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                callback(nil, error as AnyObject?)
            } else {
                
                if let data = data{
                    print(self.convertDataToString(data))
                    let dict = self.convertJsonDataToDictionary2(data)
                    //dump(dict)
                    //print(dict)
                    callback(dict as AnyObject?, nil)
                    
                }else{
                    
                    callback(nil, nil)
                    
                }
                
            }
            
        })
        task.resume()

        
    }
    
    
    func createResource(_ resource : Resources, data : Dictionary<String, AnyObject>, callback:@escaping (_ data : AnyObject?, _ error: AnyObject?)->()) -> Void{
        
        let postData = convertDictionaryToJsonData(data)
        
        var request = URLRequest(url: URL(string: "\(baseUrl)\(resource.rawValue)")!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = urlSession() //URLSession.shared

        let task = session.uploadTask(with: request as URLRequest,
              from: postData, completionHandler: {
                (data, response, error) -> Void in
                
                if let data = data{
                    
                    let dict =  self.convertJsonDataToDictionary(data)
                    callback(dict as AnyObject?, nil)
                    
                }else{
                    
                    callback(nil, nil)
                    
                    
                }
                
        }) 
        task.resume()

        
        
    }
    
    
    func delete(_ resource: Resources, resourceId: String, callback:@escaping (_ success: Bool, _ error: AnyObject?)->()) -> Void{
        /*print("server:\(baseUrl)/\(resource.rawValue)/\(resourceId)")
        let UrlTest :String = "http://fleamarket.site.swiftengine.net/items.ssp/15E5C983-B95B-41E7-8F9D-18E6D458C0D3"
        guard let urlTest = URL(string: UrlTest) else {
            print("error creating url")
            return
        }*/
        
        var request : URLRequest = URLRequest(url: URL(string: "\(baseUrl)\(resource.rawValue)/\(resourceId)")!) // cachepolicy
       // var request : URLRequest = URLRequest(url: urlTest)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = urlSession()
        let task = session.dataTask(with: request, completionHandler: {
            (data, resource, error) -> Void in
            if error != nil {
                callback(false, error as AnyObject?)
                print("error")
            }else{
                callback(true, nil)
                print("servernsuccess")
            }
        })
        
        task.resume()
        
    }
    
    
    
    
    
    func convertDataToString(_ inputData : Data) -> NSString?{
        
        let returnString = String(data: inputData, encoding: String.Encoding.utf8)
        //print(returnString)
        return returnString as NSString?
        
    }
    
    
    func convertDictionaryToJsonData(_ inputDict : Dictionary<String, AnyObject>) -> Data?{
        
        do{
            return try JSONSerialization.data(withJSONObject: inputDict, options:JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error as NSError{
            print(error)
            
        }
        
        return nil
    }
    
    
    func convertJsonDataToDictionary(_ inputData : Data) -> Array<[String:AnyObject]>? {
        guard inputData.count > 1 else{ return nil }  // avoid processing empty responses
        
        do {
           /* let json = try JSONSerialization.jsonObject(with: inputData, options: []) as? Array<Dictionary<String, AnyObject>>
            if let products = json?[0]["product"] as? [String]{
                print(products)
            }*/
            return try JSONSerialization.jsonObject(with: inputData, options: []) as? Array<Dictionary<String, AnyObject>>
        }catch let error as NSError{
            print(error)
            
        }
        return nil
    }
    
   func convertJsonDataToDictionary2(_ inputData : Data) -> Array<[String:AnyObject]>? {
        guard inputData.count > 1 else{ return nil }
        //var results = Array<[String:AnyObject]>()
        do {
                let json = try JSONSerialization.jsonObject(with: inputData) as? [String: Any]
                let data = json?["data"] as! [[String: Any]]
                return data as Array<[String : AnyObject]>
        }catch{
                print(error)
        }
        return nil
    }
    
    func convertJsonStringToDictionary(_ text: String) -> Array<Dictionary<String, AnyObject>>? {
        
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Array<Dictionary<String, AnyObject>>
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

    
    
    
    
    
    
    
}
