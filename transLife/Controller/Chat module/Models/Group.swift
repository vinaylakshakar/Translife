//
//  Group.swift
//  Quick Chat
//
//  Created by Nithin Reddy Gaddam on 4/5/17.
//  Copyright © 2017 Nithin Reddy Gaddam. All rights reserved.
//

struct Group {
    let id: String
    let name: String
    let createdBy: User
    var users = [User]()
    
    init(id: String, name: String, createdBy: User, users:[User]) {
        self.id = id
        self.name = name
        self.createdBy = createdBy
        self.users = users
    }
}
