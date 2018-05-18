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
        
        
        
        viewDidAppear(false)
        
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        timePicker.backgroundColor = UIColor.clear
        let date = Date()
        let calendar = Calendar.current
        let ActualHour = calendar.component(.hour, from: date) + 23
        let actualMinutes = calendar.component(.minute, from: date) + 120
        if((ActualHour - 23) < 12){
            self.amPM = "AM"
            hour = Int16(ActualHour - 23 )
            timePicker.selectRow(0, inComponent: 2, animated: false)
        } else if((ActualHour - 23) > 12) {
            self.amPM = "PM"
             hour = Int16(ActualHour - 35 )
            timePicker.selectRow(1, inComponent: 2, animated: false)
        }
        
       
        minutes = Int16(actualMinutes)
        timePicker.selectRow(ActualHour, inComponent: 0, animated: false)
        timePicker.selectRow(actualMinutes, inComponent: 1, animated: false)
        
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
            
            self.hour = Int16(hoursArray[row % 12])
            
        } else if(component == 1){
            
            self.minutes = Int16(minutesArray[row % 60])
            
        } else{
            self.amPM = amPMArray[row]
           
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
    
    
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
       
        var label: UILabel? = (view as? UILabel)
        
        if label == nil {
            label = UILabel()
        }
        label?.textColor = UIColor.white
        label?.font = UIFont(name: "HKGrotesk-SemiBoldLegacy", size:30)
        label?.textAlignment = .center
        if component == 0 {

            label?.text = hoursArray[row % 12]
            return label!
        }else if component == 1 {
           
            label?.text = minutesArray[row % 60]
            return label!
        }
        
        label?.text = amPMArray[row]
        return label!
       
    }

    
    
    @IBAction func saveAlarm(_ sender: Any) {
        
        print("hours are " + String(hour))
        print("minutes are " + String(minutes))
        print("am is " + amPM)
        _  = Alarm(enabled: true, hour: hour, numberOfMinutes: minutes, amORPM: amPM, insertIntoManagedObjectContext: managedObjectContext)
        
         dismiss(animated: true, completion: nil)
    }
    
    
}



