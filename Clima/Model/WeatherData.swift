
import Foundation


struct WeatherData: Decodable{
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable{
    let temp: Double
}

struct Weather: Decodable{
    let id: Int
    let description: String
    let icon: String
}


struct WeatherInfo {
    let city: String
    let temperature: Double
    let iconName: String
}
