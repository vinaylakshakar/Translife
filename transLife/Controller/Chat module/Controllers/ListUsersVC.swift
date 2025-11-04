//
//  ListUsersVC.swift
//  transLife
//
//  Created by Silstone Group on 21/06/19.
//  Copyright © 2019 Developer Silstone. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ListUsersVC: UITableViewController {
    
    static let cellId = "cellId"
    var messages = [Message]()
    var messageDict = [String:Message]()
    var users: [User] = []
    let messageRef = Database.database().reference(withPath: "Messages")
    let usersRef = Database.database().reference(withPath: "usersChat")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background_black"))
        navigationItem.title = "Chats"
        let rightButtonItem = UIBarButtonItem.init(
            image: UIImage(named: "add-user"),
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //Setting the colour of the Nav bar
        UINavigationBar.appearance().tintColor = UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 0.8)
        
        //make nav bar darker
        UINavigationBar.appearance().alpha = 0
        navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.isTranslucent = true
        
        usersRef.observe(.value, with: { snapshot in
            var newUsers = Set<User>()
            for user in snapshot.children {
                let currentUser = User(snapshot: user as! DataSnapshot)
                if(currentUser.key != Auth.auth().currentUser?.uid){
                    newUsers.insert(currentUser)
                }
            }
            
            //unique users
            
            self.users = Array(Set(newUsers))
            self.tableView.register(UserCell.self, forCellReuseIdentifier: UsersViewController.cellId)
            
            self.tableView.reloadData()
        })
        
        tableView.separatorColor = UIColor.rgb(229, green: 231, blue: 235)
        tableView.sectionHeaderHeight = 26
        
        tableView.register(UsersViewCell.self, forCellReuseIdentifier: UsersViewController.cellId)
    }
    override func viewWillAppear(_ animated: Bool) {
       // observemessages()
    }
    @objc func rightButtonAction(sender: UIBarButtonItem){
        print("rightButtonItemTapped")
    }
    //OBSERVING LAST SENT MESSAGES
    func observemessages()  {
        messageRef.observe(.childAdded) { (snap) in
            if let dictionary = snap.value as? [String:AnyObject]{
                let message = Message(dictionary:dictionary)
                self.messages.append(message)
                
                if let toId = message.toId{
                    self.messageDict[toId] = message
                    self.messages = Array(self.messageDict.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return message1.timestamp!.intValue > message2.timestamp!.intValue
                    })
                }
                self.tableView.reloadData()
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersViewController.cellId, for: indexPath) as! UserCell
        //  let message = messages[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "SegoeUI-Semibold", size: 15)
        if(user.online == true){
            cell.detailTextLabel?.text = "Online"
            cell.detailTextLabel?.textColor = UIColor.green
        } else {
            cell.detailTextLabel?.text = "Offline"
            cell.detailTextLabel?.textColor = UIColor.red
        }
        // cell.message = message
        cell.profileImageView.image = UIImage(named:user.avatar)
        
        //        if let profileimageUrl = Auth.auth().currentUser?.photoURL {
        //            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileimageUrl.path)
        //        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.tableView.cellForRow(at: indexPath) != nil else { return }
        let tempUser = users[indexPath.row]
        let chatLogController = ChatViewController(collectionViewLayout:UICollectionViewFlowLayout())
        chatLogController.user = tempUser
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func toAnyObject(tempUser:User) -> Any {
        return [
            "user1": tempUser.key,
            "user2": Auth.auth().currentUser?.uid
        ]
    }
}
