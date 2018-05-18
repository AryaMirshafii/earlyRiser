//
//  Alarm.swift
//  EarlyRiser
//
//  Created by Arya Mirshafii on 4/28/18.
//  Copyright © 2018 aryaMirshafii. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import  AVFoundation
import NotificationCenter
import UserNotifications

@objc(Alarm)
public class Alarm: NSManagedObject, UNUserNotificationCenterDelegate {
    private var timer:Timer!
    private  var player: AVAudioPlayer!
    private var context: NSManagedObjectContext!
    @NSManaged  var hour: Int16
    @NSManaged  var minutes: Int16
    @NSManaged  var amPm: String
    @NSManaged  var isEnabled: Bool
    @NSManaged var totalTime:Int64
    
    
    convenience init(enabled: Bool, hour : Int16, numberOfMinutes : Int16, amORPM: String, insertIntoManagedObjectContext objectContext: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entity(forEntityName: "Alarm", in: objectContext)!
        self.init(entity: entity, insertInto: objectContext)
        self.hour = hour
        self.amPm = amORPM
        self.minutes = numberOfMinutes
        self.isEnabled = enabled
        self.context = objectContext
        self.totalTime = 0
        save()
        initializeTimer()
        print("Created new alarm set for " + String(hour)  + ":" + String(numberOfMinutes) + " " + amORPM)
        UNUserNotificationCenter.current().delegate = self
       
    }
    
    
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        
        completionHandler([.alert, .sound])
    }
    
    
    
    
    
    private func save(){
        do {
            try context.save()
            
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    private func initializeTimer(){
        let date = Date()
        let calendar = Calendar.current
        var ActualHour = calendar.component(.hour, from: date)
        let actualMinutes = calendar.component(.minute, from: date)
        let actualSeconds = calendar.component(.second, from: date)
        
        if(ActualHour > 12) {
            ActualHour = ActualHour - 12
        }
       
        let currentTime:Int64 = Int64((actualMinutes * 60) + (ActualHour * 3600) + actualSeconds)
        
        
        
        totalTime = Int64(abs(hour * 3600))
        totalTime  = totalTime + Int64(minutes * 60) - currentTime
        
        self.setValue(totalTime, forKey: "totalTime")
        self.save()
        //print("The timer time is" + String(time))
        //print("the current times is" + String(currentTime))
        print("The timer will ring in " + String(totalTime) + "seconds")
        
        
        
        //timer = Timer.scheduledTimer(timeInterval: TimeInterval(totalTime), target: self,      selector: #selector(playsong), userInfo: nil, repeats: false)
        
        
        timedNotifications(inSeconds: TimeInterval(totalTime)) { (success) in
            if success {
                print("Successfully Set Alarm")
            }
        }
    }
    
    
    
    func timedNotifications(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let content = UNMutableNotificationContent()
    
        content.title = "Alarm is ringing!!!!"
        
        
    
        content.sound = UNNotificationSound(named: "takingCareOfAlarm.m4a")
        
        
    
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            }else {
                completion(true)
            }
        }
    }
    
    
    
    
    
    @objc private func playsong(){
        //timer.invalidate()
       timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(alarmSequence), userInfo: nil, repeats: true)
        
        print("Alarm is ringing")
        
        let path = Bundle.main.path(forResource: "takingCareOfAlarm.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
       
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            print("Song PLayed")
            self.setValue(false, forKey: "isEnabled")
            self.save()
            
            


        } catch {
            
        }
        
        
    }
    
    func getTimeStrings() -> String{
        if(minutes < 10){
            return String(format: "%d:%02d", hour, minutes)
        }
        return String(format: "%d:%d", hour,minutes)
    }
    
    
    
    
    
    
    private var timerCounter = 0
    @objc func alarmSequence(){
        if(timerCounter == 120){
            self.timer.invalidate()
           
        } else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            timerCounter += 1
        }
        
        
    }
    
}

