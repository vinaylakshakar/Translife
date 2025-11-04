//
//  User.swift
//  Quick Chat
//
//  Created by Nithin Reddy Gaddam on 4/5/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//
import Firebase

struct User : Hashable, Equatable{
    let avatar: String
    let key: String
    let name: String
    let online: Bool
    let ref: DatabaseReference?
    var hashValue: Int { get { return key.hashValue } }
    
    init(key: String, name: String, online: Bool,avatar: String) {
        self.key = key
        self.name = name
        self.online = online
        self.ref = nil
        self.avatar = avatar
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as? String ?? ""
        online = snapshotValue["online"] as? Bool ?? false
        ref = snapshot.ref
        avatar = snapshotValue["avatar_name"] as? String ?? "image_placeholder"
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "online": online,
            "avatar_name":avatar
        ]
    }
    
    func toOffline() -> Any {
        return [
            "name": name,
            "online": false,
            "avatar_name":avatar
        ]
    }
    
    static func ==(left:User, right:User) -> Bool {
        return left.key == right.key
    }
}
