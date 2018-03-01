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
    var region: CLBeaconRegion?
    var manager: CLLocationManager?
    var nClase = " "
    var funciona = " "
    let miBaliza = Baliza(uuid: "f7826da6-4fa2-4e98-8024-bc5b71e0893e",
                          major: 58387,
                          minor: 33802,
                          id: "com.jaureguialzo.ejemplobeacon")
    @IBOutlet weak var contadorSOS: SRCountdownTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contadorSOS.delegate = self
        enableLocationServices()
        
        
       
        manager?.delegate = self
        self.manager = CLLocationManager()
        region = CLBeaconRegion(proximityUUID: UUID(uuidString: miBaliza.uuid)!, identifier: miBaliza.id)
        
        
         locationManager.delegate = self
        
    }
    
   func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
        manager.startRangingBeacons(in: region as! CLBeaconRegion) // Para pruebas
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
        
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
     
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if(beacons.count == 0) {return}
        
        let beacon = beacons.last!
        
        if (beacon.proximity == .unknown) {
            funciona = "Desconocida"
            return
        } else if (beacon.proximity == .immediate) {
            funciona = "Muy cerca"
            
        } else if (beacon.proximity == .near) {
            funciona = "Cerca"
        } else if (beacon.proximity == .far) {
            funciona = "Lejos"
        }
        
       
        
    }
    func enableLocationServices() {
        //locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            nClase = "No tenemos acceso a la localización"
            
            break
            
        case .authorizedWhenInUse:
            nClase = "Localización sólo al usar la aplicación"
            
            break
            
        case .authorizedAlways:
            nClase = "Localización permanente"
            
            break
        }
    
    }

   
    
    
    @IBAction func test(_ sender: Any) {
        
        self.manager?.requestAlwaysAuthorization()
        self.manager?.startMonitoring(for: self.region!)
        locationManager.startUpdatingLocation()
    
        let alertController = UIAlertController(title: "iOScreator", message:
            nClase+funciona, preferredStyle: UIAlertControllerStyle.alert)
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


}
