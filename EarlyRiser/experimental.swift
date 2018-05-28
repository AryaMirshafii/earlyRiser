//
//  experimental.swift
//  EarlyRiser
//
//  Created by Arya Mirshafii on 5/11/18.
//  Copyright © 2018 aryaMirshafii. All rights reserved.
//

import Foundation
import UIKit
import UICircularProgressRing
import CoreData
import NotificationCenter
import UserNotifications
import MediaPlayer


class experimental: UIViewController{
    
    
    @IBOutlet weak var mainAlarmView: UIView!
    
    
    @IBOutlet weak var alarm1View: UICircularProgressRingView!
    @IBOutlet weak var alarm2View: UICircularProgressRingView!
    @IBOutlet weak var alarm3View: UICircularProgressRingView!
    @IBOutlet weak var alarm4View: UICircularProgressRingView!
    @IBOutlet weak var alarm5View: UICircularProgressRingView!
    @IBOutlet weak var alarm6View: UICircularProgressRingView!
    
    
    
    //MainAlarmLabel
    @IBOutlet weak var mainAlarmAMPMLabel: UILabel!
    @IBOutlet weak var mainAlarmTimeLabel: UILabel!
    
    
    
    //Alarm 1 labels
    @IBOutlet weak var alarm1AMPMLabel: UILabel!
    @IBOutlet weak var alarm1TimeLabel: UILabel!
    
    
    
    
    //Alarm 2 labels
    @IBOutlet weak var alarm2AMPMLabels: UILabel!
    @IBOutlet weak var alarm2TimeLabel: UILabel!
    
    
    
    //Alarm 3 labels
    @IBOutlet weak var alarm3AMPMLabel: UILabel!
    @IBOutlet weak var alarm3TimeLabel: UILabel!
    
    
    //Alarm 4 labels
    @IBOutlet weak var alarm4AMPMLabel: UILabel!
    @IBOutlet weak var alarm4TimeLabel: UILabel!
    
    
    //Alarm 5 labels
    
    @IBOutlet weak var alarm5AMPMLabels: UILabel!
    @IBOutlet weak var alarm5TimeLabel: UILabel!
    
    
    //Alarm 6 labels
    @IBOutlet weak var alarm6AMPMLabel: UILabel!
    @IBOutlet weak var alarm6TimeLabel: UILabel!
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var noAlarmsView: UIView!
    
    
    
    private var alarms:[Alarm]!
    private var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var ringManager = alarmRinger()
    private var firstAlarm: Alarm!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (MPMediaLibrary.authorizationStatus() != .authorized){
            MPMediaLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    
                    print("Music Libaray is Authorized")
                    
                }
                
                
                
            }
        }
        
        updateData()
        configureAlarms()
        
        let notificationCenter = NotificationCenter.default
        
        //notificationCenter.addObserver(self, selector: #selector(self.updateData), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(self.updateData), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        
        
        
        notificationCenter.addObserver(self, selector: #selector(self.alarmRingDidChange), name: UserDefaults.didChangeNotification, object: nil)
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
            }
        }

    }
    
    @objc func alarmRingDidChange(){
        if(ringManager.getRingingState()){
            performSegue(withIdentifier: "normalAlarm", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "normalAlarm"){
            updateData()
            var alarmView = segue.destination as! normalAlarmView
            alarmView.theAlarm = firstAlarm
        }
    }
    
    
    
    private func configureAlarms(){
        mainAlarmView.isHidden = true
        
        alarm1View.isHidden = true
        alarm2View.isHidden = true
        alarm3View.isHidden = true
        alarm4View.isHidden = true
        alarm5View.isHidden = true
        alarm6View.isHidden = true
        noAlarmsView.isHidden = false
        
        
        
        var sevenAlarms = [Alarm]()
        for anAlarm in alarms{
            if(anAlarm.isEnabled){
                sevenAlarms.append(anAlarm)
            }
        }
       
        if(sevenAlarms.isEmpty || alarms.isEmpty){
            
            return
        }
        
        noAlarmsView.isHidden = true
        
        if(sevenAlarms.count == 1){
            noAlarmsView.isHidden = true
            mainAlarmView.isHidden = false
            mainAlarmAMPMLabel.text = sevenAlarms[0].amPm
            if(sevenAlarms[0].minutes < 10){
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":0" + String(sevenAlarms[0].minutes)
            } else {
                 mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":" + String(sevenAlarms[0].minutes)
            }
           
        }else if(sevenAlarms.count == 2){
            
            
            
            mainAlarmView.isHidden = false
            mainAlarmAMPMLabel.text = sevenAlarms[0].amPm
            if(sevenAlarms[0].minutes < 10){
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":0" + String(sevenAlarms[0].minutes)
            } else {
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":" + String(sevenAlarms[0].minutes)
            }
            
            
            alarm2View.isHidden = false
            alarm2AMPMLabels.text = sevenAlarms[1].amPm
    
            if(sevenAlarms[1].minutes < 10){
                alarm2TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":0" + String(sevenAlarms[1].minutes)
            } else {
                alarm2TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":" + String(sevenAlarms[1].minutes)
            }
            
            
        }else if(sevenAlarms.count == 3){
           
            
            
            mainAlarmView.isHidden = false
            mainAlarmAMPMLabel.text = sevenAlarms[0].amPm
            if(sevenAlarms[0].minutes < 10){
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":0" + String(sevenAlarms[0].minutes)
            } else {
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":" + String(sevenAlarms[0].minutes)
            }
            
            
            alarm2View.isHidden = false
            alarm2AMPMLabels.text = sevenAlarms[1].amPm
            
            if(sevenAlarms[1].minutes < 10){
                alarm2TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":0" + String(sevenAlarms[1].minutes)
            } else {
                alarm2TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":" + String(sevenAlarms[1].minutes)
            }
            
            
            
            
            alarm5View.isHidden = false
            alarm5AMPMLabels.text = sevenAlarms[2].amPm
            
            if(sevenAlarms[2].minutes < 10){
                alarm5TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":0" + String(sevenAlarms[2].minutes)
            } else {
                alarm5TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":" + String(sevenAlarms[2].minutes)
            }
            
            
           
            
        } else if(sevenAlarms.count == 4){
            
            alarm2View.isHidden = true
            
            mainAlarmView.isHidden = false
            mainAlarmAMPMLabel.text = sevenAlarms[0].amPm
            if(sevenAlarms[0].minutes < 10){
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":0" + String(sevenAlarms[0].minutes)
            } else {
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":" + String(sevenAlarms[0].minutes)
            }
            
            
            
            
            
            
            
            
            
            alarm4View.isHidden = false
            
            alarm4AMPMLabel.text = sevenAlarms[1].amPm
            if(sevenAlarms[1].minutes < 10){
                alarm4TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":0" + String(sevenAlarms[1].minutes)
            } else {
                alarm4TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":" + String(sevenAlarms[1].minutes)
            }
            
            
            
            
            
            alarm5View.isHidden = false
            
            alarm5AMPMLabels.text = sevenAlarms[2].amPm
            if(sevenAlarms[2].minutes < 10){
                alarm5TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":0" + String(sevenAlarms[2].minutes)
            } else {
                alarm5TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":" + String(sevenAlarms[2].minutes)
            }
            
            
            alarm6View.isHidden = false
        
            alarm6AMPMLabel.text = sevenAlarms[3].amPm
            if(sevenAlarms[3].minutes < 10){
                alarm6TimeLabel.text =  "" + String(sevenAlarms[3].hour) + ":0" + String(sevenAlarms[3].minutes)
            } else {
                alarm6TimeLabel.text =  "" + String(sevenAlarms[3].hour) + ":" + String(sevenAlarms[3].minutes)
            }
            
        }else if(sevenAlarms.count == 5){
            
            
            
            mainAlarmView.isHidden = false
            mainAlarmAMPMLabel.text = sevenAlarms[0].amPm
            if(sevenAlarms[0].minutes < 10){
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":0" + String(sevenAlarms[0].minutes)
            } else {
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":" + String(sevenAlarms[0].minutes)
            }
            
            
            
            
            alarm5View.isHidden = true
            
            alarm1View.isHidden = false
            alarm1AMPMLabel.text = sevenAlarms[1].amPm
            if(sevenAlarms[1].minutes < 10){
                alarm1TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":0" + String(sevenAlarms[1].minutes)
            } else {
                alarm1TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":" + String(sevenAlarms[1].minutes)
            }
            
            
            alarm3View.isHidden = false
            alarm3AMPMLabel.text = sevenAlarms[2].amPm
            if(sevenAlarms[2].minutes < 10){
                alarm3TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":0" + String(sevenAlarms[2].minutes)
            } else {
                alarm3TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":" + String(sevenAlarms[2].minutes)
            }
            
            
            alarm4View.isHidden = false
            alarm4AMPMLabel.text = sevenAlarms[3].amPm
            if(sevenAlarms[3].minutes < 10){
                alarm4TimeLabel.text =  "" + String(sevenAlarms[3].hour) + ":0" + String(sevenAlarms[3].minutes)
            } else {
                alarm4TimeLabel.text =  "" + String(sevenAlarms[3].hour) + ":" + String(sevenAlarms[3].minutes)
            }
            
            
            
            
            alarm6View.isHidden = false
            alarm6AMPMLabel.text = sevenAlarms[4].amPm
            if(sevenAlarms[4].minutes < 10){
                alarm6TimeLabel.text =  "" + String(sevenAlarms[4].hour) + ":0" + String(sevenAlarms[4].minutes)
            } else {
                alarm6TimeLabel.text =  "" + String(sevenAlarms[4].hour) + ":" + String(sevenAlarms[4].minutes)
            }
        }else if(sevenAlarms.count == 6){
            
            alarm1View.isHidden = false
            alarm2View.isHidden = false
            alarm3View.isHidden = false
            alarm4View.isHidden = false
            alarm6View.isHidden = false
            
            alarm5View.isHidden = true
            
            
            
            
            
            mainAlarmView.isHidden = false
            mainAlarmAMPMLabel.text = sevenAlarms[0].amPm
            if(sevenAlarms[0].minutes < 10){
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":0" + String(sevenAlarms[0].minutes)
            } else {
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":" + String(sevenAlarms[0].minutes)
            }
            
            
            
            
            alarm1AMPMLabel.text = sevenAlarms[1].amPm
            if(sevenAlarms[1].minutes < 10){
                alarm1TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":0" + String(sevenAlarms[1].minutes)
            } else {
                alarm1TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":" + String(sevenAlarms[1].minutes)
            }
            
            
            
            alarm2AMPMLabels.text = sevenAlarms[2].amPm
            if(sevenAlarms[2].minutes < 10){
                alarm2TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":0" + String(sevenAlarms[2].minutes)
            } else {
                alarm2TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":" + String(sevenAlarms[2].minutes)
            }
            
            
            
            alarm3AMPMLabel.text = sevenAlarms[3].amPm
            if(sevenAlarms[3].minutes < 10){
                alarm3TimeLabel.text =  "" + String(sevenAlarms[3].hour) + ":0" + String(sevenAlarms[3].minutes)
            } else {
                alarm3TimeLabel.text =  "" + String(sevenAlarms[3].hour) + ":" + String(sevenAlarms[3].minutes)
            }
            
            
            
            
            
            alarm4AMPMLabel.text = sevenAlarms[3].amPm
            if(sevenAlarms[4].minutes < 10){
                alarm4TimeLabel.text =  "" + String(sevenAlarms[4].hour) + ":0" + String(sevenAlarms[4].minutes)
            } else {
                alarm4TimeLabel.text =  "" + String(sevenAlarms[4].hour) + ":" + String(sevenAlarms[4].minutes)
            }
            
            
            
            
            
            alarm6AMPMLabel.text = sevenAlarms[3].amPm
            if(sevenAlarms[5].minutes < 10){
                alarm6TimeLabel.text =  "" + String(sevenAlarms[5].hour) + ":0" + String(sevenAlarms[5].minutes)
            } else {
                alarm6TimeLabel.text =  "" + String(sevenAlarms[5].hour) + ":" + String(sevenAlarms[5].minutes)
            }
        }
        if(sevenAlarms.count == 7){
            
            alarm1View.isHidden = false
            alarm2View.isHidden = false
            alarm3View.isHidden = false
            alarm4View.isHidden = false
            alarm5View.isHidden = false
            alarm6View.isHidden = false
            
            mainAlarmView.isHidden = false
            mainAlarmAMPMLabel.text = sevenAlarms[0].amPm
            if(sevenAlarms[0].minutes < 10){
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":0" + String(sevenAlarms[0].minutes)
            } else {
                mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":" + String(sevenAlarms[0].minutes)
            }
            
            alarm1AMPMLabel.text = sevenAlarms[1].amPm
            if(sevenAlarms[1].minutes < 10){
                alarm1TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":0" + String(sevenAlarms[1].minutes)
            } else {
                alarm1TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":" + String(sevenAlarms[1].minutes)
            }
            
            
            
            alarm2AMPMLabels.text = sevenAlarms[2].amPm
            if(sevenAlarms[2].minutes < 10){
                alarm2TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":0" + String(sevenAlarms[2].minutes)
            } else {
                alarm2TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":" + String(sevenAlarms[2].minutes)
            }
            
            
            
            alarm3AMPMLabel.text = sevenAlarms[3].amPm
            if(sevenAlarms[3].minutes < 10){
                alarm3TimeLabel.text =  "" + String(sevenAlarms[3].hour) + ":0" + String(sevenAlarms[3].minutes)
            } else {
                alarm3TimeLabel.text =  "" + String(sevenAlarms[3].hour) + ":" + String(sevenAlarms[3].minutes)
            }
            
            
            
            
            
            alarm4AMPMLabel.text = sevenAlarms[4].amPm
            if(sevenAlarms[4].minutes < 10){
                alarm4TimeLabel.text =  "" + String(sevenAlarms[4].hour) + ":0" + String(sevenAlarms[4].minutes)
            } else {
                alarm4TimeLabel.text =  "" + String(sevenAlarms[4].hour) + ":" + String(sevenAlarms[4].minutes)
            }
            
            
            
            
            
            alarm5AMPMLabels.text = sevenAlarms[5].amPm
            if(sevenAlarms[5].minutes < 10){
                alarm5TimeLabel.text =  "" + String(sevenAlarms[5].hour) + ":0" + String(sevenAlarms[5].minutes)
            } else {
                alarm5TimeLabel.text =  "" + String(sevenAlarms[5].hour) + ":" + String(sevenAlarms[5].minutes)
            }
            
            
            alarm6AMPMLabel.text = sevenAlarms[6].amPm
            if(sevenAlarms[6].minutes < 10){
                alarm6TimeLabel.text =  "" + String(sevenAlarms[6].hour) + ":0" + String(sevenAlarms[6].minutes)
            } else {
                alarm6TimeLabel.text =  "" + String(sevenAlarms[6].hour) + ":" + String(sevenAlarms[6].minutes)
            }
        }
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateData()
        
    }
    
   
    @objc private func updateData() {
        print("Data updated")
        let alarmFetch: NSFetchRequest<Alarm> = Alarm.fetchRequest() as! NSFetchRequest<Alarm>
        do {
            alarms = try managedObjectContext.fetch(alarmFetch) as! [Alarm]
        } catch {
            fatalError("Failed to fetch alarms: \(error)")
        }
        
        
        if(!alarms.isEmpty){
            alarms = alarms.sorted(by: { $0.totalTime > $1.totalTime })
            firstAlarm = alarms[0]
            
        }
        var count = 0
        var tempAlarm = [Alarm]()
        for anAlarm in alarms{
            if(anAlarm.isEnabled == true){
                tempAlarm.append(anAlarm)
            }
            
        }
        alarms = tempAlarm
        
        
        
        if(!alarms.isEmpty){
           alarms = alarms.sorted(by: { $0.totalTime > $1.totalTime })
        
        }
        
        configureAlarms()
        
        
    }
    
    
    
    
    private func addProgress(view: UIView, xCoord:Int, yCord:Int){
       
    }
}
