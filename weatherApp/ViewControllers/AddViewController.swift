//
//  AddViewController.swift
//  weatherApp
//
//  Created by Danilo Costa on 17/09/2021.
//

import UIKit
import MapKit
import CoreLocation

class AddViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameTextView: UITextField!
    
    var lat = ""
    var long = ""
    var cityName = ""
    var dici: [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addButton.isEnabled = false
        nameTextView.isEnabled = false
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
    }
    


    @IBAction func addTapped(_ sender: Any) {
        cityName =  self.nameTextView.text!
         
        //set cityModel
        var newCity = CityModel()
        newCity.lat = lat
        newCity.long = long
        newCity.name = cityName
        
        var nsDictionary: NSDictionary?
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let path:NSString = documentsPath.appendingPathComponent("Configs.plist") as NSString;
        
        nsDictionary = NSMutableDictionary(contentsOfFile: path as String)
        var dicionaryOfCities = nsDictionary?.value(forKey: "SavedCity") as? [String: Any] ?? [:]
            let dicionaryOfCoords = NSDictionary(dictionary: ["lat": lat, "long": long])
            dicionaryOfCities[cityName] = dicionaryOfCoords
            nsDictionary?.setValue(dicionaryOfCities, forKey: "SavedCity")
        
        

        
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Selected Location"
            let annotations = mapView.annotations
            mapView.removeAnnotations(annotations)
            self.mapView.addAnnotation(annotation)
        lat = String(format: "%f", location.latitude )
        long = String(format: "%f", location.longitude )
        
        coodsToFriendly(friendLat: location.longitude, friendLong: location.longitude)
        addButton.isEnabled = true
    }
    
    @IBAction func editingTextField(_ sender: Any) {
        if self.nameTextView.text !=  ""{
            self.addButton.isEnabled = true
        } else {
            self.addButton.isEnabled = false
        }
    }
    func coodsToFriendly(friendLat:CLLocationDegrees, friendLong:CLLocationDegrees ){
        let location = CLLocation(latitude: friendLat, longitude: friendLong)
        location.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            if placemark.city != nil {
                self.nameTextView.text = placemark.city
            } else {
                let alert = UIAlertController(title: "Alert", message: "We could not find the name of the plac in the map can you please write for us?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.nameTextView.isEnabled = true
                self.addButton.isEnabled = false
            }
        }
    }
    
}

extension AddViewController:MKMapViewDelegate{

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.black
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped on pin ")
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if (view.annotation?.title!) != nil {
               print("do something")
            }
        }
      }
}

