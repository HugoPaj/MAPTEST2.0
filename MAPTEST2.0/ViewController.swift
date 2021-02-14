//
//  ViewController.swift
//  MAPTEST2.0
//
//  Created by Hugo Paja Guallar on 26.10.20.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
 
    fileprivate let locationManager = CLLocationManager ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.mapType = .satellite
        
        segmentedControl.addTarget(self, action: #selector(switchtype), for: .valueChanged)
        
    }
    
    
    
    fileprivate func addAnnotationToMap() {
        let annotation = MKPointAnnotation()
        annotation.title = "Dusseldorf"
        annotation.subtitle = "Hello"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.2277, longitude: 6.7735)
       // annotation.coordinate = mapView.userLocation.coordinate
        mapView.addAnnotation(annotation)
    }
    
    
    @objc fileprivate func switchtype(){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .satellite
        case 1:
            mapView.mapType = .standard
        case 2:
            mapView.mapType = .hybrid
        default:
            return
        }
    }
    
    
    @IBAction func pinAddress(_ sender: Any) {
        
        print("Hit the search button")
        let alertController = UIAlertController(title: "Enter Address", message: "We need your address for geocoding", preferredStyle: .alert)
        
        alertController.addTextField { (tf) in}
        
        let saveButton =  UIAlertAction(title: "Search", style: .default) { (action) in
            if let tf = alertController.textFields?.first {
                let addressText = tf.text!
                self.geoCodeAnnotate(addressText: addressText)
            }
        }
        
        alertController.addAction(saveButton)
        present(alertController, animated: true, completion: nil)
    
    }

    fileprivate func geoCodeAnnotate(addressText: String){
        
        //declare Geocoder
        
            let geoCoder = CLGeocoder()
        
        //geocode address string
       
            geoCoder.geocodeAddressString(addressText) { (placemarks, err) in
        
        // if err print the err and return or break out
            
            if let err = err {
                print(err.localizedDescription); return
            }
       
        //check the first placemark
            
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
  
        //get directions
            
            let coordinates = placemark?.location?.coordinate
            let destinationInformation = MKPlacemark(coordinate: coordinates!)
       
            let startingPoint = MKMapItem.forCurrentLocation()
            let destinationPoint = MKMapItem(placemark: destinationInformation)
            
            let directionsReq = MKDirections.Request()
            directionsReq.transportType = .walking
            directionsReq.source = startingPoint
            directionsReq.destination = destinationPoint
             
            let directions = MKDirections(request: directionsReq)
                directions.calculate { (response, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        return
                    }
            
                    if let response = response {
                        guard let route = response.routes.first else { return }
                        let steps = route.steps
                        if !steps.isEmpty{
                            for step in steps {
                                print("next step:", step.instructions)
                            }
                        }
                        
                        self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                        
                    }
                    
                }
                
        //open in maps app
            
//            let coordinates = placemark?.location?.coordinate
//            let destinationInformation = MKPlacemark(coordinate: coordinates!)
//            let mapitem = MKMapItem(placemark: destinationInformation)
//
//            MKMapItem.openMaps(with: [mapitem], launchOptions: nil)
           
        //pin address to map
                
//            let coordinates = placemark?.location?.coordinate
//            let newAnnotation = MKPointAnnotation()
//            newAnnotation.coordinate = coordinates ?? CLLocationCoordinate2D (latitude: 20, longitude: 20)
//            self.mapView.addAnnotation(newAnnotation)
            
            
        }
  
        
    }
    
}
    extension ViewController: CLLocationManagerDelegate {
}

extension ViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue.withAlphaComponent(0.8)
        renderer.lineWidth = 6
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        let cluster = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        cluster.title = "Large Cities"
        cluster.subtitle = "Great places to visit"
        return cluster
    }
    
    fileprivate func setupMapSnapshot(annotation: MKAnnotationView){
        let options = MKMapSnapshotter.Options()
        options.size = CGSize(width: 200, height: 200)
        options.mapType = .hybridFlyover
        let center = annotation.annotation?.coordinate ?? CLLocationCoordinate2D   (latitude: 20, longitude: 20)
        options.camera = MKMapCamera(lookingAtCenter: center, fromDistance: 150, pitch: 60, heading: 0)
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { (snapshot, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                //image view
                //set the image views image to the snapshot image
                //let the annotation detail callout view to the imageview
                let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                imageview.image = snapshot.image
                annotation.detailCalloutAccessoryView = imageview
            }
        }
    }
    
    func mapView(_ mapView:MKMapView, didUpdate userlocation:
    MKUserLocation){
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
        addAnnotationToMap()
        
        }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
      //  var marker =mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") as? MKMarkerAnnotationView)
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        marker.glyphText = "City"
        marker.canShowCallout = true
        marker.clusteringIdentifier = "Large Locations"
        //marker.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "pin"))
       // marker.rightCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "chevron"))
        setupMapSnapshot(annotation: marker)
        return marker
    }
    }
