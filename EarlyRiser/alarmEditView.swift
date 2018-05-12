//
//  alarmEditView.swift
//  EarlyRiser
//
//  Created by Arya Mirshafii on 4/28/18.
//  Copyright © 2018 aryaMirshafii. All rights reserved.
//

import Foundation
import  UIKit
import HEDatePicker
extension String {
    subscript(_ i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }
}
class alarmEditView: UIViewController, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var timePicker: UIDatePicker!
    private var hour:Int16!
    private var minutes:Int16!
    private var amPM:String!
    private var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timePicker.datePickerMode = .time
        
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        timePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @objc func datePickerChanged(sender:UIDatePicker) {
        
        
        
        //dateFormatter.dateFormat = "hh:mm a"
        let timeFormatter: DateFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        timeFormatter.locale = NSLocale.system
        
        
        
        //hour = Int16(timeFormatter.string(from: sender.date))
        //minutes = Int16(timeFormatter.string(from: sender.date))
        let alarmTime:String = timeFormatter.string(from: sender.date)
        self.hour = Int16(alarmTime[0] + alarmTime[1])
        self.minutes = Int16(alarmTime[3] + alarmTime[4])
        self.amPM = alarmTime[6] + alarmTime[7]
        
    
    }
    
    
    @IBAction func saveAlarm(_ sender: Any) {
        var myAlarm = Alarm(enabled: true, hour: hour, numberOfMinutes: minutes, amORPM: amPM, insertIntoManagedObjectContext: managedObjectContext)
        
         dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "HKGrotesk-BoldItalic", size: 40)
        
    
        
        
        return label
    }
}



