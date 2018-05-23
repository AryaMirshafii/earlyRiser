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
        
        
        
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(self.updateData), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
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
            return
        }else{
            alarms = alarms.sorted(by: { $0.totalTime > $1.totalTime })
        }
        
        
        
        
    }
    
    
    
    
    private func addProgress(view: UIView, xCoord:Int, yCord:Int){
       
    }
}
