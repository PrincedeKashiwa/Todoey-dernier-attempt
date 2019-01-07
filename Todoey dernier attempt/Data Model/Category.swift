//
//  Category.swift
//  Todoey dernier attempt
//
//  Created by BRUNO SMITH on 07/01/2019.
//  Copyright © 2019 BRUNO SMITH. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() //Initializing this as an empty list containing Item objects, list is like an array
    // [Int]() is equivalent to Array<Int>(), inside each catgory there is this thing cxalled items that points to item objects
    
}
