//
//  ViewController.swift
//  ProyextoValizas
//
//  Created by Carlos Hernández on 31/1/18.
//  Copyright © 2018 Carlos Hernández. All rights reserved.
//

import UIKit

import SRCountdownTimer
import CoreLocation

class ViewController: UIViewController, SRCountdownTimerDelegate , CLLocationManagerDelegate{
    
let locationManager = CLLocationManager()
    var beaconRegion: CLBeaconRegion!
    var manager: CLLocationManager?
 
   
    
    let miBaliza = Baliza(uuid: "f7826da6-4fa2-4e98-8024-bc5b71e0893e",
                          major: 58387,
                          minor: 33802,
                          id: "com.jaureguialzo.ejemplobeacon")
    
   
    
    @IBOutlet weak var contadorSOS: SRCountdownTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contadorSOS.delegate = self

        self.manager = CLLocationManager()
        manager?.delegate = self
        enableLocationServices()
    
         beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: miBaliza.uuid)!, identifier: miBaliza.id)
        
    }
    
       
        
    
    func enableLocationServices() {
        //locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            print("No tenemos acceso a la localización")
            
            break
            
        case .authorizedWhenInUse:
            print("Localización sólo al usar la aplicación")
            
            break
            
        case .authorizedAlways:
           print("Localización permanente")
            
            break
        }
    
    }

   
    
    
    @IBAction func test(_ sender: Any) {
        
        self.manager?.startMonitoring(for: self.beaconRegion!)
    
        let alertController = UIAlertController(title: "iOScreator", message:
            "Aqui el mensajito", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelar(_ sender: UIButton) {
        //este es el que cancela la accion
        contadorSOS.start(beginingValue: 3)
        contadorSOS.pause()
        
    }
    
    
    @IBAction func mantener(_ sender: UIButton) {
        //este boton es el que inicia
        contadorSOS.start(beginingValue: 3)
    }
    
    
    
    
    func timerDidEnd() {
        
        //envia el aviso
        print("SOS!!!!")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager,
                         didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didDetermineState state: CLRegionState,
                         for region: CLRegion) {
        if state == .inside {
            locationManager.startRangingBeacons(in: beaconRegion)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didRangeBeacons beacons: [CLBeacon],
                         in region: CLBeaconRegion) {
        
        guard let nearestBeacon = beacons.first else { return }
        
        switch nearestBeacon.proximity {
        case .far:
            print("Lejos")
        case .immediate:
            view.backgroundColor = .green
            print("Cerca")
        case .near:
            view.backgroundColor = .yellow
            print("Medio")
        default:
            view.backgroundColor = .red
            print("Otro")
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print(error.localizedDescription)
    }

}
