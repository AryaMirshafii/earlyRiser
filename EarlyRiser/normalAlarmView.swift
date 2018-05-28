//
//  normalAlarmView.swift
//  EarlyRiser
//
//  Created by Arya Mirshafii on 5/27/18.
//  Copyright © 2018 aryaMirshafii. All rights reserved.
//

import Foundation
import UIKit

class normalAlarmView:UIViewController {
    
    
    var theAlarm: Alarm!
    private var alarmRingManager = alarmRinger()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    @IBAction func disableButton(_ sender: Any) {
        
        theAlarm.disableAlarm()
        alarmRingManager.setRingState(state: false)
        dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func snoozeButton(_ sender: Any) {
        
        
        dismiss(animated: false, completion: nil)
    }
    
}
