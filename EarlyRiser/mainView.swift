//
//  mainView.swift
//  EarlyRiser
//
//  Created by Arya Mirshafii on 4/27/18.
//  Copyright © 2018 aryaMirshafii. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MediaPlayer

class mainView: UITableViewController {
    private var alarms:[Alarm]!
    private var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 90
        self.updateData()
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateData()
        self.tableView.reloadData()
    }
    private func updateData() {
        
        let alarmFetch: NSFetchRequest<Alarm> = Alarm.fetchRequest() as! NSFetchRequest<Alarm>
        do {
            alarms = try managedObjectContext.fetch(alarmFetch) as! [Alarm]
        } catch {
            fatalError("Failed to fetch alarms: \(error)")
        }
        
        
        if(alarms.isEmpty){
            return
        }else{
            alarms = alarms.sorted(by: { $0.totalTime > $1.totalTime })
        }
        
    }
    // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.alarms.count
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:alarmCell = self.tableView.dequeueReusableCell(withIdentifier: "alarmCell") as! alarmCell
        let alarm = alarms[indexPath.row]
        
        cell.theAlarm = alarm
        cell.enableSwitch.isOn = alarm.isEnabled
        cell.determineSwitch()
        cell.timeLabel.text = alarm.getTimeStrings()
        cell.amPMLabel.text = alarm.amPm
        
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    @IBAction func exit(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    
    
    
    
    
}
