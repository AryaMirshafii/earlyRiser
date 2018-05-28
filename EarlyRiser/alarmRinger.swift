//
//  alarmRinger.swift
//  EarlyRiser
//
//  Created by Arya Mirshafii on 5/27/18.
//  Copyright © 2018 aryaMirshafii. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class alarmRinger{
    struct defaultsKeys {
        static let isRinging = false
        
        
        
        
    }
    
    private var context:NSManagedObjectContext!
    
    init(){
        self.context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    
    func getRingingState()  -> Bool{
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: "isRinging")
        
    }
    
    
    func setRingState(state: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(state, forKey: "isRinging")
        print("Updated ring state to " + String(state))
    }
    

}
