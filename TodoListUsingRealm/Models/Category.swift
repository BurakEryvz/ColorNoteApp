//
//  Category.swift
//  TodoListUsingRealm
//
//  Created by Burak Eryavuz on 25.06.2023.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name: String = ""
    
    //İleri (düz) ilişki tanımlandı.
    let items = List<Item>()
    
    
}
