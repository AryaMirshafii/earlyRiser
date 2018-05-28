//
//  alarmEditView.swift
//  EarlyRiser
//
//  Created by Arya Mirshafii on 4/28/18.
//  Copyright © 2018 aryaMirshafii. All rights reserved.
//

import Foundation
import  UIKit
import MediaPlayer
import ASHorizontalScrollView

import HEDatePicker
extension String {
    subscript(_ i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }
}
class alarmEditView: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    
    @IBOutlet weak var whiteView: UIView!
    
    
   
    
    @IBOutlet weak var alarmSoundTableView: UITableView!
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    @IBOutlet weak var currentAlarmSound: UILabel!
    
    @IBOutlet weak var alarmTypeSelector: ASHorizontalScrollView!
    
    
    
    private var hour:Int64!
    private var minutes:Int64!
    private var amPM:String!
    private var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var hoursArray = [String]()
    private var minutesArray = [String]()
    private var amPMArray = [String]()
    let pickerDataSize = 100_000
    private var selectedSoundCellIndex:Int!
    private var currentToneName = "Default"
    override func viewDidLoad() {
        super.viewDidLoad()
        whiteView.layer.cornerRadius = 15
        
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
        
        alarmSoundTableView.numberOfRows(inSection: 1)
        alarmSoundTableView.layer.cornerRadius = 10
        alarmSoundTableView.delegate = self
        alarmSoundTableView.dataSource = self
        
        let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: 135, height: 40))
        let button2 = UIButton(frame: CGRect(x: 0, y: 0, width: 135, height: 40))
        //let button3 = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
       // let button4 = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        
        button1.backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
        button2.backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
        //button3.backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
        //button4.backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
        
        button1.setTitle("Normal", for: .normal)
        button2.setTitle("Motion", for: .normal)
        
        
        button1.layer.cornerRadius = 8
        button2.layer.cornerRadius = 8
        
        
        button1.titleLabel?.font =  UIFont(name: "HKGrotesk-SemiBoldLegacy", size: 20)
        button2.titleLabel?.font =  UIFont(name: "HKGrotesk-SemiBoldLegacy", size: 20)
        
        
        
        //button1.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)
        //button2.addTarget(self, action: #selector(button2Tapped), for: .touchUpInside)
        
        alarmTypeSelector.uniformItemSize = CGSize(width: 160, height: 40)
        alarmTypeSelector.addItems([button1,button2])
        alarmTypeSelector.layer.cornerRadius = 10
        
       
        alarmTypeSelector.clipsToBounds = true
        if (MPMediaLibrary.authorizationStatus() != .authorized){
            MPMediaLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    
                    print("Music Libaray is Authorized")
                    
                }else {
                    self.alarmSoundTableView.isHidden = true
                }
                
                
                
            }
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if (MPMediaLibrary.authorizationStatus() != .authorized){
            return 1
        }
        return (MPMediaQuery.songs().items?.count)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! alarmSoundCell
        cell.isSelectedImage.isHidden = false
        if(selectedSoundCellIndex == nil){
            selectedSoundCellIndex = Int(indexPath.row)
            currentToneName = String(cell.alarmSoundLabel.text!)
            currentAlarmSound.text = "Tone: " + currentToneName
        }else {
            let theIndexPath = IndexPath(row: selectedSoundCellIndex, section: 0)
            let previousSelection = tableView.cellForRow(at: theIndexPath) as! alarmSoundCell
            previousSelection.isSelectedImage.isHidden = true
            selectedSoundCellIndex = Int(indexPath.row)
            currentToneName = String(cell.alarmSoundLabel.text!)
            currentAlarmSound.text = "Tone: " + currentToneName
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmSoundCell") as! alarmSoundCell
        
        cell.alarmSoundLabel.text = MPMediaQuery.songs().items?[indexPath.row].title
        cell.isSelectedImage.isHidden = true
        
        return cell
    }
    
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        //timePicker.backgroundColor = UIColor.clear
        let date = Date()
        let calendar = Calendar.current
        let ActualHour = calendar.component(.hour, from: date) + 23
        let actualMinutes = calendar.component(.minute, from: date) + 120
        if((ActualHour - 23) < 12){
            self.amPM = "AM"
            hour = Int64(ActualHour - 23 )
            timePicker.selectRow(0, inComponent: 2, animated: false)
        } else if((ActualHour - 23) > 12) {
            self.amPM = "PM"
             hour = Int64(ActualHour - 35 )
            timePicker.selectRow(1, inComponent: 2, animated: false)
        }
        
       
        minutes = Int64(actualMinutes)
        if(minutes >= 120){
            minutes = minutes - 120
        }
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
            
            self.hour = Int64(hoursArray[row % 12])
            
        } else if(component == 1){
            
            self.minutes = Int64(minutesArray[row % 60])
            
        } else{
            self.amPM = amPMArray[row]
           
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(component == 0){
            self.hour = Int64(hoursArray[row % 12])
            return hoursArray[row % 12]
        } else if(component == 1){
            self.minutes = Int64(minutesArray[row % 60])
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
        label?.textColor = UIColor.black
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
        _  = Alarm(enabled: true, hour: hour, numberOfMinutes: minutes, amORPM: amPM, insertIntoManagedObjectContext: managedObjectContext,tone: currentToneName)
        
         dismiss(animated: true, completion: nil)
    }
    
    
}



