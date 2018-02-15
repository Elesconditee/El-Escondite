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
    
    var nClase = " "
    
    @IBOutlet weak var contadorSOS: SRCountdownTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contadorSOS.delegate = self
        
       
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if(beacons.count == 0) { return }
        
        let beacon = beacons.last!
        
        if (beacon.proximity == .unknown) {
            nClase = "Desconocida"
            return
        } else if (beacon.proximity == .immediate) {
            nClase = "Muy cerca \(beacon.major)"
            
            
        } else if (beacon.proximity == .near) {
            nClase = "Cerca"
        } else if (beacon.proximity == .far) {
            nClase = "Lejos"
        }
        
       
        
    }

    
    @IBAction func test(_ sender: Any) {
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        
        let alertController = UIAlertController(title: "iOScreator", message:
            nClase, preferredStyle: UIAlertControllerStyle.alert)
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

