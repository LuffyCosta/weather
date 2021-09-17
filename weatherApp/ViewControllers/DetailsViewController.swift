//
//  DetailsViewController.swift
//  weatherApp
//
//  Created by Danilo Costa on 17/09/2021.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var weatherText: UILabel!
    @IBOutlet weak var tempText: UILabel!
    @IBOutlet weak var humidText: UILabel!
    @IBOutlet weak var rainText: UILabel!
    @IBOutlet weak var windText: UILabel!
    
    
    var searchData: [WeatherInfoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherDataManager.sharedInstance.goGetInfo(completion:{ [self]
            array in
            self.searchData = array
            setupUI()
        })
    }
    
    
    func setupUI() {
        
        var weatherInfo = searchData.first! as WeatherInfoModel
        
        DispatchQueue.main.async {
            self.weatherText.text = String(format: "Weather: %@", weatherInfo.weather!)
            self.tempText.text = String(format: "Temp: %@", weatherInfo.temp!)
            self.humidText.text = String(format: "Humidity: %@", weatherInfo.humid!)
            self.rainText.text = String(format: "rain %: %@", weatherInfo.rain!)
            self.windText.text = String(format: "Wind speed: %@", weatherInfo.wind!)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
