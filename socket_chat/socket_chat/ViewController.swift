//
//  ViewController.swift
//  socket_chat
//
//  Created by WLD_MBP_20 on 09/12/2015.
//  Copyright © 2015 leeprobert. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var messagesTableView: UITableView!
    
    var messages = [String]()
    
    let socket = SocketIOClient(socketURL: "localhost:3000")
    
    @IBAction func sendHandler(sender: AnyObject) {
        
        if inputTextField.text != "" {
            socket.emit("chat message", inputTextField.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.connect()
        
        socket.on("chat message") {[weak self] data, ack in
         
            // add new message to array of messages and redraw table
            self!.messages.append(String(data))
            self!.messagesTableView.reloadData()
            self!.inputTextField.text = ""
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: tableView delegate/datasource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "messageCell")
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }

}

