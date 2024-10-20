import CoreLocation
import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl: String = "https://api.openweathermap.org/data/2.5/weather?appid=693512be484e844931c9a2d921256f74&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. create URL
        
        if let url = URL(string: urlString) {
            // 2. create URLSession
            let session = URLSession(configuration: .default)
            
            // 3. give session a task
//           let task: URLSessionDataTask = session.dataTask(with: url, completionHandler: handle(data:respons*/e:error:))
            
            let task: URLSessionDataTask = session.dataTask(with: url) { data, _, error in
                if error != nil {
//                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = parseJson(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // 4. start task
            task.resume()
        }
    }
    
    func parseJson(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let parsedData: WeatherData = try decoder.decode(WeatherData.self, from: weatherData)
            print(parsedData.name ?? "")
            
            let id = parsedData.weather.first?.id
            let city = parsedData.name
            let temp = parsedData.main.temp
            
            let weather = WeatherModel(conditionId: id ?? 0, cityName: city ?? "pune", temprature: temp)
            
            print(weather.temperatureString)
            
            return weather
            
        } catch {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
//    func handle(data: Data?, response: URLResponse?, error: Error?) {
//        if error != nil {
//            print(error!)
//            return
//        }
//
//        if let safeData = data {
//            let dataString = String(data: safeData, encoding: .utf8)
//
//            print(dataString)
//        }
//    }
}
