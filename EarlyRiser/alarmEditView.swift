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
class alarmEditView: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    
    
   
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    private var hour:Int16!
    private var minutes:Int16!
    private var amPM:String!
    private var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var hoursArray = [String]()
    private var minutesArray = [String]()
    private var amPMArray = [String]()
    let pickerDataSize = 100_000
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
        
        for hour in 1...12{
             hoursArray.append(String(hour))
        }
       
        for minute in 0...59{
             minutesArray.append(String(minute))
        }
        
        amPMArray.append("AM")
        amPMArray.append("PM")
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.layer.cornerRadius = 20
        timePicker.clipsToBounds = true
        timePicker.selectRow(12, inComponent: 0, animated: false)
        timePicker.selectRow(60, inComponent: 1, animated: false)
        timePicker.backgroundColor = UIColor.clear
        
       
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title:String
        if(component == 0){
            title = hoursArray[row % 12]
        } else if(component == 1){
            title =  minutesArray[row % 60]
        } else {
            title =  amPMArray[row]
        }
        
        
        
        let myTitle = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font:UIFont(name: "HKGrotesk-SemiBoldLegacy", size: 25.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(component == 0){
            //return hoursArray.count
            return pickerDataSize
        } else if(component == 1){
            //return minutesArray.count
            return pickerDataSize
        }
        return amPMArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            //return hoursArray.count
            self.hour = Int16(hoursArray[row % 12])
            let position = pickerDataSize/2 + row
            pickerView.selectRow(position, inComponent: 0, animated: false)
        } else if(component == 1){
            //return minutesArray.count
            self.minutes = Int16(minutesArray[row % 60])
            let position = pickerDataSize/2 + row
            pickerView.selectRow(position, inComponent: 1, animated: false)
        } else{
            self.amPM = amPMArray[row]
            pickerView.selectRow(row, inComponent: 2, animated: false)
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(component == 0){
            self.hour = Int16(hoursArray[row % 12])
            return hoursArray[row % 12]
        } else if(component == 1){
            self.minutes = Int16(minutesArray[row % 60])
            return minutesArray[row % 60]
        }
        self.amPM = amPMArray[row]
        return amPMArray[row]
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
        print("hours are " + String(hour))
        print("minutes are " + String(minutes))
        print("am is " + amPM)
        let anAlarm  = Alarm(enabled: true, hour: hour, numberOfMinutes: minutes, amORPM: amPM, insertIntoManagedObjectContext: managedObjectContext)
        
         dismiss(animated: true, completion: nil)
    }
    
    
}



