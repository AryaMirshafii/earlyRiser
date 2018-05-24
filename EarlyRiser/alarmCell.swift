//
//  alarmCell.swift
//  EarlyRiser
//
//  Created by Arya Mirshafii on 4/27/18.
//  Copyright © 2018 aryaMirshafii. All rights reserved.
//

import Foundation
import UIKit

class alarmCell: UITableViewCell{
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amPMLabel: UILabel!
    
    @IBOutlet weak var enableSwitch: UISwitch!
    var theAlarm: Alarm!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
   
    
    
    
    @IBAction func switchChanged(_ sender: Any) {
        
        self.determineSwitch()
    }
    
    func determineSwitch(){
        if(enableSwitch.isOn == true){
            theAlarm.enableAlarm()
        } else{
            
            theAlarm.disableAlarm()
            enableSwitch.layer.cornerRadius = enableSwitch.frame.height / 2
            enableSwitch.backgroundColor = UIColor(red:0.00, green:0.40, blue:1.00, alpha:1.0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
