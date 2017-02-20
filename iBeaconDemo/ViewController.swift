//
//  ViewController.swift
//  iBeaconDemo
//
//  Created by 汪俊 on 2016/10/12.
//  Copyright © 2016年 Codans. All rights reserved.
//

import UIKit
import CoreLocation

var UUID_STRING = "F62D3F65-2FCB-AB76-00AB-68186B10300D"
var NAME_STRING = "Apple"

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var uuidLable: UILabel!
    @IBOutlet weak var showDistanceLable: UILabel!
    
    var locationManager:CLLocationManager!
    var ibeacon:CLBeaconRegion!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setDefailtViewValues()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let uuid = NSUUID(UUIDString: UUID_STRING)
        let major:CLBeaconMajorValue = 18
        let minor:CLBeaconMajorValue = 17
        
        ibeacon = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: NAME_STRING)
        
        locationManager.startMonitoringForRegion(ibeacon)
        locationManager.startRangingBeaconsInRegion(ibeacon)
        locationManager.requestStateForRegion(ibeacon)
        locationManager.startUpdatingLocation()
        
    }
    
    // MARK: - 设置默认的页面显示内容
    func setDefailtViewValues() {
        imageView.image = UIImage(named: "single-miss")
        nameLable.text = "miss"
        uuidLable.text = "XXXX-XXXX-XXXX"
        showDistanceLable.text = "&"
        showDistanceLable.textColor = UIColor.lightGrayColor()
    }
    
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        nameLable.text = region.identifier
        
        for beacon in beacons {
           
            if beacon.major == 18 && beacon.minor == 17 {
                changeView(beacon)
            }
        }
    }

    func changeView(beacon:CLBeacon){
        switch beacon.proximity {
            
        case .Unknown:
            print("0.未知")
            setDefailtViewValues()
            return
        case .Immediate:
            print("1.贴近 \(beacon.accuracy)")
           
            showDistanceLable.textColor = UIColor(red: 0.153, green: 0.631, blue: 0.388, alpha: 1)
        case .Near:
            print("2.较近 \(beacon.accuracy)")
            
            showDistanceLable.textColor = UIColor(red: 0.996, green: 0.804, blue: 0.318, alpha: 1)
        case .Far:
            print("3.较远 \(beacon.accuracy)")
            showDistanceLable.textColor = UIColor(red: 0.863, green: 0.322, blue: 0.290, alpha: 1)
        }
        imageView.image = UIImage(named: "single")
        uuidLable.text = beacon.proximityUUID.UUIDString
        showDistanceLable.text = String(format: "%.1f",calcDistByRSSI(beacon.rssi) * 0.7)

    }
    
    
//    // 根据信号强度计算距离
    func calcDistByRSSI(rssi:Int) -> Float {
        let iRssi = abs(rssi)
        let power = ((Float(iRssi)) - 65.0) / (10 * 2.0)
        return pow(10, power)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

