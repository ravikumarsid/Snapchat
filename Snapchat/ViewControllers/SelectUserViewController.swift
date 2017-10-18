//
//  SelectUserViewController.swift
//  Snapchat
//
//  Created by Ravi Kumar Venuturupalli on 10/15/17.
//  Copyright © 2017 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SelectUserViewController: UIViewController, UITableViewDataSource,  UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var users : [User] = []
    var imageURL = ""
    var descrip = ""
    var uuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        Database.database().reference().child("users").observe(DataEventType.childAdded) { (snapshot) in
            print(snapshot)
            
            let user = User()

            user.email = (snapshot.value as! NSDictionary)["email"] as! String
            user.uid = snapshot.key
            
            self.users.append(user)
            
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let snap = ["from": user.email, "description": descrip, "imageURL": imageURL, "uuid": uuid]
    Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
    
        navigationController!.popToRootViewController(animated: true)
    }

}
