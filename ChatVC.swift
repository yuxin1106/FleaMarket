//
//  ChatVC.swift
//  FleaMarket
//
//  Created by Xin Yu on 11/18/17.
//  Copyright © 2017 Xin Yu. All rights reserved.
//
/*
import UIKit
import TwilioChatClient

class ChatVC: UIViewController {

    //Important - update this URL
    let tokenURL = "http://localhost:8000/token.php"
    
    
    // MARK: Chat variables
    var client: TwilioChatClient? = nil
    var generalChannel: TCHChannel? = nil
    var identity = ""
    var messages: [TCHMessage] = []
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ChatVC.keyboardWillShow),
                                               name:Notification.Name.UIKeyboardWillShow,
                                               object: nil);
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ChatVC.keyboardDidShow),
                                               name:Notification.Name.UIKeyboardDidShow,
                                               object: nil);
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ChatVC.keyboardWillHide),
                                               name:Notification.Name.UIKeyboardWillHide,
                                               object: nil);
        
        // Set up UI controls
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 66.0
        self.tableView.separatorStyle = .none

    }

   
    override func viewDidAppear(_ animated: Bool) {
        // Create the general channel (for public use) if it hasn't been created yet
        
        let options = [
            TCHChannelOptionFriendlyName: "General Channel",
            TCHChannelOptionType: TCHChannelType.public.rawValue
            ] as [String : Any]
        client?.channelsList().createChannel(options: options, completion: { channelResult, channel in
            if (channelResult?.isSuccessful())! {
                print("Channel created.")
            } else {
                print("Channel NOT created.")
            }
        })
        
        super.viewDidAppear(animated)
        login()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logout()
    }

    
    // MARK: Login / Logout
    
    func login() {
        // Fetch Access Token from the server and initialize Chat Client - this assumes you are running
        // the PHP starter app on your local machine, as instructed in the quick start guide
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let urlString = "\(tokenURL)?device=\(deviceId)"
        
        TokenUtils.retrieveToken(url: urlString) { (token, identity, error) in
            if let token = token, let identity = identity {
                self.identity = identity
                // Set up Twilio Chat client
                TwilioChatClient.chatClient(withToken: token, properties: nil, delegate: self) {
                    (result, chatClient) in
                    self.client = chatClient;
                    // Update UI on main thread
                    DispatchQueue.main.async() {
                        self.navigationItem.prompt = "Logged in as \"\(self.identity)\""
                    }
                }
            } else {
                print("Error retrieving token: \(error)")
            }
            
        }

    }
    
    func logout() {
        if let client = client {
            client.delegate = nil
            client.shutdown()
            self.client = nil
        }
    }

    // MARK: Keyboard Dodging Logic
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.bottomConstraint.constant = keyboardRect.height + 10
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        self.scrollToBottomMessage()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 20
            self.view.layoutIfNeeded()
        })
    }
    
    
    // Scroll to bottom of table view for messages
    func scrollToBottomMessage() {
        if self.messages.count == 0 {
            return
        }
        let bottomMessageIndex = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)
    }


}

// MARK: Twilio Chat Delegate
extension ChatVC: TwilioChatClientDelegate {
    
    func chatClient(_ client: TwilioChatClient!, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        if status == .completed {
            // Join (or create) the general channel
            let defaultChannel = "general"
            client.channelsList().channel(withSidOrUniqueName: defaultChannel, completion: { (result, channel) in
                if let channel = channel {
                    self.generalChannel = channel
                    channel.join(completion: { result in
                        print("Channel joined with result \(result)")
                        
                    })
                } else {
                    // Create the general channel (for public use) if it hasn't been created yet
                    client.channelsList().createChannel(options: [TCHChannelOptionFriendlyName: "General Chat Channel", TCHChannelOptionType: TCHChannelType.public.rawValue], completion: { (result, channel) -> Void in
                        if let result = result {
                            if result.isSuccessful() {
                                self.generalChannel = channel
                                self.generalChannel?.join(completion: { result in
                                    self.generalChannel?.setUniqueName(defaultChannel, completion: { result in
                                        print("channel unique name set")
                                    })
                                })
                            }
                        }
                    })
                }
            })
            
            
        }
    }
    
    // Called whenever a channel we've joined receives a new message
    func chatClient(_ client: TwilioChatClient!, channel: TCHChannel!,
                    messageAdded message: TCHMessage!) {
        self.messages.append(message)
        self.tableView.reloadData()
        DispatchQueue.main.async() {
            if self.messages.count > 0 {
                self.scrollToBottomMessage()
            }
        }
    }
}



// MARK: UITextField Delegate
extension ChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let messages = self.generalChannel?.messages {
            let msg = messages.createMessage(withBody: textField.text!)
            messages.send(msg) { result in
                textField.text = ""
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
}


// MARK: UITableViewDataSource Delegate
extension ChatVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // Return number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    // Create table view rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
            let message = self.messages[indexPath.row]
            
            // Set table cell values
            cell.detailTextLabel?.text = message.author
            cell.textLabel?.text = message.body
            cell.selectionStyle = .none
            return cell
    }
}
*/


import UIKit

class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var itemTable2: UITableView!
    fileprivate var items2 : Array<Item>!
    fileprivate var contacts : Array<Item>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //reloadTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
       
    }
    
    func reloadTableView(){
        
        PostsManager.readPostsWithHandler{
            (items2 : Array<Item>?, error: AnyObject?) in
            
            self.items2 = items2
            // create contacts from the items retrieved from the server
            self.contacts = self.items2.filterDuplicates{$0.cSeller == $1.cSeller && $0.cPhone == $1.cPhone}
            // load list of contacts async
            DispatchQueue.main.async(
                execute: {
                    () -> Void in
                    
                    // Background Task here
                    var bTask : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
                    bTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                        UIApplication.shared.endBackgroundTask(bTask)
                        bTask  = UIBackgroundTaskInvalid
                        print("expirationHandler Termination")
                        
                    })
                    // reload tableview data
                    self.itemTable2.reloadData()
                    
                    UIApplication.shared.endBackgroundTask(bTask)
                    bTask  = UIBackgroundTaskInvalid
                    
                    print("Background Done 2")
                    
            })
            
            
        }
        
    }
    // UITableViewDataSource Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     // UITableViewDataSource Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contacts = contacts{
            return contacts.count
            //print(items.count)
        }
        return 0
        /*if let items2 = items2{
            return items2.count
            //print(items.count)
        }
        return 0*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // tableview cell subtitle style
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        let item : Item = self.contacts[(indexPath as NSIndexPath).row]
        
        cell.detailTextLabel?.text = item.cPhone
        cell.textLabel?.text = item.cSeller
        
        return cell
        
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? UITableViewCell {
            let i = itemTable2.indexPath(for: cell)?.row
            if segue.identifier == "ToSMS2" {
                let vc = segue.destination as! SMSVC
                vc.pickedItem = contacts[i!]
            }
        }
    }
    

}
// extension to filter out the duplicates in an array
extension Array {
    
    func filterDuplicates( includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}




















