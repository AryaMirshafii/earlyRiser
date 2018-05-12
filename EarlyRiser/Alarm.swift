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


@objc(Alarm)
public class Alarm: NSManagedObject {
    private var timer:Timer!
    private  var player: AVAudioPlayer!
    private var context: NSManagedObjectContext!
    @NSManaged  var hour: Int16
    @NSManaged  var minutes: Int16
    @NSManaged  var amPm: String
    @NSManaged  var isEnabled: Bool
    @NSManaged var totalTime:Int32
    
    
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
        let currentTime:Int32 = Int32((actualMinutes * 60) + (ActualHour * 3600) + actualSeconds)
        
        
        
        totalTime += abs((Int32(hour) * 3600) + (Int32(minutes) * 60) - currentTime)
        //print("The timer time is" + String(time))
        //print("the current times is" + String(currentTime))
        print("The timer will ring in " + String(totalTime) + "seconds")
        
        
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(totalTime), target: self,      selector: #selector(playsong), userInfo: nil, repeats: false)
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
            self.isEnabled = false
            self.save()
        } catch {
            
        }
        
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

