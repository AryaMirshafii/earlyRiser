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
import MediaPlayer

@objc(Alarm)
public class Alarm: NSManagedObject, UNUserNotificationCenterDelegate {
    private var timer:Timer!
    //private  var player: AVAudioPlayer!
    private var context: NSManagedObjectContext!
    @NSManaged var hour: Int64
    @NSManaged var minutes: Int64
    @NSManaged var amPm: String
    @NSManaged var isEnabled: Bool
    @NSManaged var totalTime:Int64
    @NSManaged var toneName:String
    
    
    var player = MPMusicPlayerController.applicationMusicPlayer
    var songs:[MPMediaItem]!
    let snooze:TimeInterval = 5.0
    
    convenience init(enabled: Bool, hour : Int64, numberOfMinutes : Int64, amORPM: String, insertIntoManagedObjectContext objectContext: NSManagedObjectContext!, tone:String) {
        let entity = NSEntityDescription.entity(forEntityName: "Alarm", in: objectContext)!
        self.init(entity: entity, insertInto: objectContext)
        self.hour = hour
        self.amPm = amORPM
        self.minutes = numberOfMinutes
        self.isEnabled = enabled
        self.context = objectContext
        self.totalTime = 0
        self.toneName = tone
        save()
        initializeTimer()
        print("Created new alarm set for " + String(hour)  + ":" + String(numberOfMinutes) + " " + amORPM)
        UNUserNotificationCenter.current().delegate = self
       
    }
    
    
    
    
    
    
    
    
    
    
    private func save(){
        if(context == nil){
            context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
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
        
        
        print("hour is: + " + String(hour))
        
        totalTime = (abs(hour * 3600))
        
        
        self.totalTime  = totalTime + Int64(minutes * 60) - currentTime
        
        self.setValue(totalTime, forKey: "totalTime")
        self.save()
        //print("The timer time is" + String(time))
        //print("the current times is" + String(currentTime))
        print("The timer will ring in " + String(totalTime) + "seconds")
        
        
        print("song" + toneName)
        
        
        
        songs =  MPMediaQuery.songs().items!.filter({ (mod) -> Bool in
            
            
            return (mod.title != nil && mod.title == toneName)
        })
        
        
        
        if(!songs.isEmpty){
            print("Songs arent empty")
             timer = Timer.scheduledTimer(timeInterval: TimeInterval(totalTime - 1), target: self,      selector: #selector(playsong), userInfo: nil, repeats: false)
        }
       
        
        
        
        
        setCategories()
        
        timedNotifications(inSeconds: TimeInterval(totalTime)) { (success) in
            if success {
                print("Successfully Set Alarm")
            }
        }
        
        
        
        
    }
    
    
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
        
        
        
    }
    
    
    private func setCategories(){
        let snoozeAction = UNNotificationAction(identifier: "Dismiss", title: "End Alarm", options: [])
        let commentAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let alarmCategory = UNNotificationCategory(identifier: "alarm.category",actions: [snoozeAction,commentAction],intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
    }
    
    
    
    func timedNotifications(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.subtitle = "First Alarm"
        content.body = "First Alarm"
        if(songs.isEmpty){
            content.sound = UNNotificationSound.default()
        }
        content.categoryIdentifier = "alarm.category"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        
        
        addNotification(content: content, trigger: trigger , indentifier: "Alarm")
        
        
       

    
        
    }
    
    
    
    func addNotification(content:UNNotificationContent,trigger:UNNotificationTrigger?, indentifier:String){
        let request = UNNotificationRequest(identifier: indentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            (errorObject) in
            if let error = errorObject{
                print("Error \(error.localizedDescription) in notification \(indentifier)")
            }
        })
    }
    
    
    
    
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        let request = response.notification.request
        if identifier == "Snooze"{
            let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
            newContent.body = "Snooze 5 Seconds"
            newContent.subtitle = "Snooze 5 Seconds"
            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: snooze, repeats: false)
            addNotification(content: newContent, trigger: newTrigger, indentifier: request.identifier)
            
        }
        
        if identifier == "Dismiss"{
            player.pause()
            if(timer != nil){
                timer.invalidate()
            }
            
        }
        
        completionHandler()
    }
    
    
    
    
    
    
    
    
    @objc private func playsong(){
        if(!isEnabled){
            if(timer != nil){
                timer.invalidate()
            }
            return
        }
        //timer.invalidate()
       timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(alarmSequence), userInfo: nil, repeats: true)
        
       
        do {
         
            print("Song PLayed")
            self.setValue(false, forKey: "isEnabled")
            self.save()
            
            


        } catch{
            
        }
        
        
        
        
       
        let mediaCollection = MPMediaItemCollection(items: [songs[0]])
        self.player.setQueue(with: mediaCollection)
        player.prepareToPlay()
        player.play()
        
        
    }
    
    func getTimeStrings() -> String{
        if(minutes < 10){
            return String(format: "%d:%02d", hour, minutes)
        }
        return String(format: "%d:%d", hour,minutes)
    }
    
    
    func enableAlarm(){
        self.isEnabled = true
        self.setValue(true, forKey: "isEnabled")
        initializeTimer()
        self.save()
    }
    
    func disableAlarm(){
        self.isEnabled = false
        self.setValue(false, forKey: "isEnabled")
        NotificationCenter.default.removeObserver(self)
        self.save()
        if(timer != nil){
            print("time is not nil")
             self.timer.invalidate()
        }
       
    }
    
    
    private var timerCounter = 0
    @objc func alarmSequence(){
        if(!isEnabled){
            return
        }
        if(timerCounter == 100_000){
            self.timer.invalidate()
           
        } else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            timerCounter += 1
        }
        
        
    }
    
}

