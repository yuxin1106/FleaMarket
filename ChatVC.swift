//
//  ChatVC.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/18/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//

import PusherSwift
import UIKit

class ChatVC: UIViewController, PusherDelegate{
    var pusher: Pusher! = nil
    
    @IBAction func connectButtonTouched(_ sender: Any) {
        pusher.connect()
    }
    
    @IBAction func disconnectButtonTouched(_ sender: Any) {
        pusher.disconnect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = PusherClientOptions(
            host: .cluster("us2")
        )
        
        pusher = Pusher(
            key: "8955c427d67598f0d94c",
            options: options
        )
        
        // subscribe to channel and bind to event
        let channel = pusher.subscribe("my-channel")
        
        let _ = channel.bind(eventName: "my-event", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                if let message = data["message"] as? String {
                    print(message)
                }
            }
        })
        
        pusher.connect()
    }
    
    
    
    // PusherDelegate methods
    
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        // print the old and new connection states
        print("old: \(old.stringValue()) -> new: \(new.stringValue())")
    }
    
    func subscribedToChannel(name: String) {
        print("Subscribed to \(name)")
    }
    
    func debugLog(message: String) {
        print(message)
    }
}
