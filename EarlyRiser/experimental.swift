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
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
            }
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
        
        
        if(sevenAlarms.count >= 1){
            noAlarmsView.isHidden = true
            mainAlarmView.isHidden = false
            mainAlarmAMPMLabel.text = sevenAlarms[0].amPm
            mainAlarmTimeLabel.text =  "" + String(sevenAlarms[0].hour) + ":" + String(sevenAlarms[0].minutes)
        }
        
        if(sevenAlarms.count >= 2){
            
            alarm2View.isHidden = false
            
            alarm2AMPMLabels.text = sevenAlarms[1].amPm
            alarm2TimeLabel.text =  "" + String(sevenAlarms[1].hour) + ":" + String(sevenAlarms[1].minutes)
            
        }
        if(sevenAlarms.count >= 3){
           
            
            alarm5View.isHidden = false
            
            alarm5AMPMLabels.text = sevenAlarms[2].amPm
            alarm5TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":" + String(sevenAlarms[2].minutes)
            
        }
        
        
        
        
        if(sevenAlarms.count >= 3){
            
            
            alarm5View.isHidden = false
            
            alarm5AMPMLabels.text = sevenAlarms[2].amPm
            alarm5TimeLabel.text =  "" + String(sevenAlarms[2].hour) + ":" + String(sevenAlarms[2].minutes)
            
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
        
        
        if(alarms.isEmpty){
            return
        }
        var count = 0
        var tempAlarm = [Alarm]()
        for anAlarm in alarms{
            if(anAlarm.isEnabled == true){
                tempAlarm.append(anAlarm)
            }
            
        }
        alarms = tempAlarm
        
        
        
        if(alarms.isEmpty){
            configureAlarms()
            return
        }else{
            alarms = alarms.sorted(by: { $0.totalTime > $1.totalTime })
        }
        
        configureAlarms()
        
        
    }
    
    
    
    
    private func addProgress(view: UIView, xCoord:Int, yCord:Int){
       
    }
}
