//
//  WeatherDataManager.swift
//  weatherApp
//
//  Created by Danilo Costa on 17/09/2021.
//

import Foundation

enum JSONError: Error {
    case InvalidURL(String)
    case InvalidKey(String)
    case InvalidArray(String)
    case InvalidData
    case InvalidImage
    case indexOutOfRange
    
}

private let baseURL = "https://api.openweathermap.org/data/2.5/weather?q=lisbon&appid=c6e381d8c7ff98f0fee43775817cf6ad"

class WeatherDataManager {
    var searchData: [WeatherInfoModel]
    public static let sharedInstance = WeatherDataManager()
   
    private init() {
        searchData = []
    }
    
    public func getWeatherInfo() -> [WeatherInfoModel]{
        return self.searchData
    }
    
    func goGetInfo(completion: @escaping ([WeatherInfoModel]) -> Void){
        let session = URLSession.shared
        let booksUrl = NSURLComponents(string: baseURL)
        let url = (booksUrl?.url!)!
        
        session.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! [String: AnyObject]
                
                var weatherdesc = ""
                    
                guard let weather = json["weather"] as! [[String: AnyObject]]? else {
                    throw JSONError.InvalidKey("weather")
                }
                
                for part in weather {
                    
                    
                    weatherdesc = part["description"] as! String
                    
                    
                }
                
                guard let weatherMain = json["main"] as! [String: AnyObject]? else {
                    throw JSONError.InvalidKey("main")
                }
            
                guard let weatherTemp = weatherMain["temp"]?.stringValue else {
                    throw JSONError.InvalidKey("temp")
                }
                
                guard let weatherhumidity = weatherMain["humidity"]?.stringValue else {
                    throw JSONError.InvalidKey("humidity")
                }
                
                
                guard let weatherclouds = json["clouds"] as! [String: AnyObject]? else {
                    throw JSONError.InvalidKey("clouds")
                }
                
                guard let rainPerCent = weatherclouds["all"]?.stringValue else {
                    throw JSONError.InvalidKey("all")
                }
                
                guard let weatherWind = json["wind"] as! [String: AnyObject]? else {
                    throw JSONError.InvalidKey("wind")
                }

                guard let windSpeed = weatherWind["speed"]?.stringValue else {
                    throw JSONError.InvalidKey("speed")
                }

                

                    let newWeather = WeatherInfoModel(weather: weatherdesc, temp: weatherTemp, humid: weatherhumidity, rain: rainPerCent, wind: windSpeed)
                    
                    self.searchData.append(newWeather)
                
                completion(self.searchData)
            } catch  {
                print("Error thrown: \(error)")
            }
        }).resume()
    }
}

