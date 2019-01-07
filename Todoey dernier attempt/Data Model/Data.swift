//
//  Data.swift
//  Todoey dernier attempt
//
//  Created by BRUNO SMITH on 06/01/2019.
//  Copyright © 2019 BRUNO SMITH. All rights reserved.
//
import RealmSwift
import Foundation
//nead objc dynamic in realm
class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
