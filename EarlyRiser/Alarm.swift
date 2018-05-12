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
    @NSManaged  var hour: Int16
    @NSManaged  var minutes: Int16
    @NSManaged  var amPm: String
    
    
    convenience init(hour : Int16, numberOfMinutes : Int16, amORPM: String, insertIntoManagedObjectContext objectContext: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entity(forEntityName: "Alarm", in: objectContext)!
        self.init(entity: entity, insertInto: objectContext)
        self.hour = hour
        self.amPm = amORPM
        self.minutes = numberOfMinutes
        print("new alarm created")
        do {
            try objectContext.save()
            print("Created new alarm set for " + String(hour)  + ":" + String(numberOfMinutes) + " " + amORPM)
            initializeTimer()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func initializeTimer(){
        let date = Date()
        let calendar = Calendar.current
        var ActualHour = calendar.component(.hour, from: date)
        let actualMinutes = calendar.component(.minute, from: date)
        let actualSeconds = calendar.component(.second, from: date)
        
        if(ActualHour > 12) {
            ActualHour = ActualHour - 12
        }
        let currentTime = (actualMinutes * 60) + (ActualHour * 3600) + actualSeconds
        
        var time:Int = 0
        
        time += abs((Int(hour) * 3600) + (Int(minutes) * 60) - currentTime)
        print("The timer time is" + String(time))
        print("the current times is" + String(currentTime))
        print("The timer will ring in " + String(time) + "seconds")
        
        
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self,      selector: #selector(playsong), userInfo: nil, repeats: false)
    }
    
    @objc private func playsong(){
        print("Alarm is rining")
        
        guard let url = Bundle.main.url(forResource: "takingCareOfAlarm", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let player = try AVAudioPlayer(contentsOf: url)
            
            player.play()
            print("Song Played!")
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

