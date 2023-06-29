//
//  Item.swift
//  TodoListUsingRealm
//
//  Created by Burak Eryavuz on 25.06.2023.
//

import Foundation
import RealmSwift
import UIKit

class Item: Object {
    @Persisted  var title: String = ""
    @Persisted  var isCheck: Bool = false
    @Persisted  var itemColorName: String = "#FFFFFF"
    
    @Persisted var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
