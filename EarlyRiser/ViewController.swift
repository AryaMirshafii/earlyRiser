//
//  ViewController.swift
//  EarlyRiser
//
//  Created by Arya Mirshafii on 4/27/18.
//  Copyright © 2018 aryaMirshafii. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    private var locationManager:CLLocationManager!
    private var currentLocation: CLLocation!
    private var startingLocation: CLLocation!
    private var endingLocation: CLLocation!

    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    
    @IBAction func startPressed(_ sender: Any) {
        startingLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
    }
    
    
    
    @IBAction func endPressed(_ sender: Any) {
        endingLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        var distance = startingLocation.distance(from: endingLocation)
        distanceLabel.text = String(format:"%f", getFeet(meters: distance))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0] as CLLocation
        
        print("user latitude = \(currentLocation.coordinate.latitude)")
        print("user longitude = \(currentLocation.coordinate.longitude)")
        
        self.latLabel.text = "\(currentLocation.coordinate.latitude)"
        self.longLabel.text = "\(currentLocation.coordinate.longitude)"
        
        
        
    }
    private func getFeet(meters: CLLocationDistance) -> CLLocationDistance{
        return meters * 3.28084
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    


}




