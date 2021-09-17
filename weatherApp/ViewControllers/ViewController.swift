//
//  ViewController.swift
//  weatherApp
//
//  Created by Danilo Costa on 17/09/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var arrayOfCities:[CityModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        reload from plist
        parseConfigGetSavedCities()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func parseConfigGetSavedCities() {
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Configs", ofType: "plist") {
           nsDictionary = NSDictionary(contentsOfFile: path)
            populateArray(cities: nsDictionary!.value(forKey: "SavedCity") as! NSDictionary)
        }
    }
    
    func populateArray(cities:NSDictionary) {
        arrayOfCities.removeAll()
        if cities.count > 0 {
            for city in cities {
                var cityToAdd = CityModel()
                cityToAdd.name = city.key as? String
                let coords =  city.value as? NSDictionary
                cityToAdd.lat = coords?.value(forKey: "lat") as? String
                cityToAdd.long = coords?.value(forKey: "long") as? String
                
                arrayOfCities.append(cityToAdd)
            }
        }
    }
    
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        cell.textLabel?.text = arrayOfCities[indexPath.row].name
        
        return cell
    }
    
    
    
}

extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

