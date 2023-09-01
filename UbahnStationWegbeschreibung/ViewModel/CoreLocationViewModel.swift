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
    
    var beaconRegions: [CLBeaconRegion] = []
    var newBeaconFound = false
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10.0
        
        DispatchQueue.main.async {
            self.locationManager.startMonitoringSignificantLocationChanges()
        }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location updated")
        
        DispatchQueue.main.async {
            self.locateBeacon()
        }
    }
    
    func locateBeacon() {
        print("Locating beacon...")
        let beaconID = "com.example.myBeaconRegion"
        // Step 1 -> F9DF84FC-1145-4D0B-9AC7-F2FAD5EFF690
        // Step 2 -> EA33B1EC-4A91-4577-9983-0978DDD237BA
        let region = CLBeaconRegion(uuid: UUID(uuidString: "EA33B1EC-4A91-4577-9983-0978DDD237BA")!, identifier: beaconID)
        
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
                print("Beacon found")
//                getBeacon(uuid: beaconRegion.uuid)
                
                if beaconRegions.contains(beaconRegion) {
                    newBeaconFound = false
                }
                else {
                    beaconRegions.append(beaconRegion)
                    newBeaconFound = true
                }
            }
            else {
                print("nein!")
            }
        }
    }
}
