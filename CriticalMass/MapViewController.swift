//
//  MapViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/18/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMapView()
    }
    
    override func loadView() {
        self.view = MKMapView(frame: .zero)
    }
    
    private var mapView: MKMapView {
        return self.view as! MKMapView
    }
    
    private func configureMapView() {
    
    }
    
}
