//
//  Category.swift
//  TodoListUsingRealm
//
//  Created by Burak Eryavuz on 25.06.2023.
//

import Foundation
import RealmSwift
import UIKit

class Category : Object {
    @Persisted var name: String = ""
    @Persisted var categoryColorName: String = "#FFFFFF"
    
    //İleri (düz) ilişki tanımlandı.
    @Persisted var items = List<Item>()
    
    
}
