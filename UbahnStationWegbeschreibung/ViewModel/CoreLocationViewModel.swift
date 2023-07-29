//
//  CoreLocationViewModel.swift
//  UbahnStationWegbeschreibung
//
//  Created by Lukas Carvajal on 7/29/23.
//

import Foundation
import CoreLocation

class CoreLocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestAlwaysPermission() {
        locationManager.requestAlwaysAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse {
            requestAlwaysPermission()
        }
    }
    
    func locateBeacon() {
        let beaconID = "com.example.myBeaconRegion"
        let region = CLBeaconRegion(uuid: UUID(uuidString: "F9DF84FC-1145-4D0B-9AC7-F2FAD5EFF690")!, identifier: beaconID)
        
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            locationManager.startMonitoring(for: region)
        }else {
           print("CLLocation Monitoring is unavailable")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Region entered")
        if let beaconRegion = region as? CLBeaconRegion {
            // Start ranging only if the devices supports this service.
            if CLLocationManager.isRangingAvailable() {
                manager.startRangingBeacons(in: region as! CLBeaconRegion)

                // Store the beacon so that ranging can be stopped on demand.
//                beaconsToRange.append(region as! CLBeaconRegion)
                print("Beacon found")
                getBeacon(uuid: beaconRegion.uuid)
            }
            else {
                print("nein!")
            }
        }
    }
}
