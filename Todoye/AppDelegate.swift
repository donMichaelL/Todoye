//
//  AppDelegate.swift
//  Todoye
//
//  Created by Michael Loukeris on 02/01/2018.
//  Copyright © 2018 Michael Loukeris. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        do {
            _ = try Realm()
        } catch {
            print("Problem initiliazing new realm, \(error)")
        }
        
        return true
    }
}

