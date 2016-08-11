//
//  ViewController.swift
//  MessengerClone
//
//  Created by Chase Wang on 7/23/16.
//  Copyright © 2016 ocwang. All rights reserved.
//

import UIKit
import SwiftPhoenixClient

class ViewController: UIViewController {

    var chat: Chat!
    
    typealias Message = Phoenix.Message
    
    // MARK: - Instance Vars
    
    lazy var topic: String = {
        return "rooms:\(self.chat.chatID)"
    }()
    
    let socket = Phoenix.Socket(domainAndPort: Constant.HerokuDomain,
                                path: "socket",
                                transport: "websocket",
                                prot: "https")
    
    var messages: [Message] = []
    
    var didSetupConstraints = false
    
    var textInputViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Subviews
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var textInputView: MCTextInputView = {
        let textInputView = MCTextInputView.fromNib()
        textInputView.translatesAutoresizingMaskIntoConstraints = false
        textInputView.backgroundColor = UIColor.brownColor()
        textInputView.textField.delegate = self
        textInputView.sendButton.addTarget(self,
                                           action: #selector(self.sendButtonTapped(_:)),
                                           forControlEvents: .TouchUpInside)
        
        return textInputView
    }()
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        let message = Message(subject: "status", body: "joining")
        socket.join(topic: topic, message: message) {
            guard let channel = $0 as? Phoenix.Channel else {
                return
            }
            
            self.setupChannel(channel)
        }
        
        view.addSubview(textInputView)
        view.setNeedsUpdateConstraints()
    }
    
    func setupChannel(channel: Phoenix.Channel) {
        channel.on("join", callback: { (message) in
            print("You joined the room")
        })
        
        channel.on("new:msg") { message in
            guard let
                message = message as? Message,
                _       = message.message?["user"],
                _       = message.message?["body"]
                else { return }
            
            self.messages.append(message)
            let newIndexPath = NSIndexPath(forRow: self.messages.count - 1, inSection: 0)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
                self.tableView.endUpdates()
            })
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // TODO: disconnect from websocket
        precondition(false)
    }
    
    // MARK: - Auto Layout
    
    func setupConstraints() {
        textInputView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        textInputView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        textInputViewBottomConstraint =
            textInputView.topAnchor.constraintEqualToAnchor(view.topAnchor)
        textInputViewBottomConstraint!.active = true
        textInputView.heightAnchor.constraintEqualToConstant(100).active = true
        
        tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            setupConstraints()
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: - Channel Helpers
    
    func sendButtonTapped(sender: UIButton) {
        guard let body = textInputView.textField.text else {
            return
        }

        sendMessage(User.currentUser!.name, body: body)
        textInputView.textField.text = ""
        textInputView.textField.resignFirstResponder()
    }
    
    func sendMessage(username: String, body: String) {
        let dict = ["user": username, "body": body]
        let message = Message(message: dict)

        let payload = Phoenix.Payload(topic: topic,
                                      event: "new:msg",
                                      message: message)
        socket.send(payload)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: MessageCell, atIndexPath indexPath: NSIndexPath) {
        let message = messages[indexPath.row]
        
        // data is a dictionary with keys that indicate the name of the field
        // and a value of type AnyObject
        let data = message.message as! Dictionary<String, SwiftPhoenixClient.JSON>
        
        guard let
            username = data["user"],
            body = data["body"]
            else { return }
        
        cell.contentLabel.text = "[\(username)] \(body)"
        cell.containerView.backgroundColor =
            String(username).containsString(User.currentUser!.name) ? .greenColor() : .redColor()
    }
}

extension ViewController: UITextFieldDelegate {
    
    // TODO: Implement Later
    
}
