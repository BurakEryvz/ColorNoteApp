//
//  Item.swift
//  TodoListUsingRealm
//
//  Created by Burak Eryavuz on 25.06.2023.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isCheck: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
