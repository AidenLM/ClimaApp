import Foundation

protocol WeatherManagerDelegate {
    
    func didReceiveWeather(_ weather: WeatherInfo)
}



struct WeatherManager {
    
    var delegate:WeatherManagerDelegate?
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=ce35bcb2f012070354fec2d3f12384c5&units=metric"
    
    func fetchWeather(cityName: String){
        
        let urlString = "\(weatherUrl)&q=\(cityName)"
        self.performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        //1.Create a URL
        if let url = URL(string: urlString){
            //2.Create URL Season
            let session = URLSession(configuration: .default) // session object
            //3.Give a season task
            let task = session.dataTask(with: url) { data, response, error in
                //5. create function for completionHandler
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData) // self is requred here because of closure
                }
            }
            //4.Start task
            task.resume()
        }
        
    }
    
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print("City:\(decodedData.name)")
            print("Temp:\(decodedData.main.temp)")
            print("Description:\(decodedData.weather[0].description)")
            print("id:\(decodedData.weather[0].id)")
            //let id = decodedData.weather[0].id
            
            let iconId = decodedData.weather[0].icon
            let iconName = getIconName(iconId: iconId)
            let weather = WeatherInfo(city: decodedData.name, temperature: decodedData.main.temp, iconName: iconName)
            
            
           
            delegate?.didReceiveWeather(weather)
        } catch{
            print(error)
        }
        
    }
    
    
    func getIconName(iconId: String) -> String{
        
        switch iconId {
            // ☀️ Clear sky
            case "01d":
                return "sun.max.fill"
            case "01n":
                return "moon.stars.fill"
                
            // 🌤 Few clouds
            case "02d":
                return "cloud.sun.fill"
            case "02n":
                return "cloud.moon.fill"
                
            // ⛅️ Scattered clouds
            case "03d", "03n":
                return "cloud.fill"
                
            // ☁️ Broken clouds
            case "04d", "04n":
                return "smoke.fill"
                
            // 🌦 Shower rain
            case "09d", "09n":
                return "cloud.drizzle.fill"
                
            // 🌧 Rain
            case "10d":
                return "cloud.sun.rain.fill"
            case "10n":
                return "cloud.moon.rain.fill"
                
            // ⛈ Thunderstorm
            case "11d", "11n":
                return "cloud.bolt.rain.fill"
                
            // ❄️ Snow
            case "13d", "13n":
                return "snowflake"
                
            // 🌫 Mist
            case "50d", "50n":
                return "cloud.fog.fill"
                
            // ❓
            default:
                return "questionmark.circle"
            }
       
    }
    
    
    
    
    

    
}
