//
//  Data.swift
//  Todoye
//
//  Created by Michael Loukeris on 16/01/2018.
//  Copyright © 2018 Michael Loukeris. All rights reserved.
//

import Foundation
import RealmSwift


class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
