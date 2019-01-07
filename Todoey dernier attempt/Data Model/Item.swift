//
//  Item.swift
//  Todoey dernier attempt
//
//  Created by BRUNO SMITH on 07/01/2019.
//  Copyright © 2019 BRUNO SMITH. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //inverse to the forward relationship described in category class, items is the name of the forward relationship, cateogry = opaqque pointer
    
}
