import Foundation

public struct Weather {
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    let pressure: String
    let humidity: String
    let speed: String
    let visibility: String
    let windDegree: String
    
    
    init(response: APIResponse) {
        city = response.name
        temperature = "\(Int(response.main.temp))"
        description = response.weather.first?.description ?? ""
        iconName = response.weather.first?.iconName ?? ""
        pressure = "\(response.main.pressure)"
        humidity = "\(Int(response.main.humidity))"
        speed = "\(response.wind.speed)"
        windDegree = "\(response.wind.deg)"
        visibility = "\(Int(response.visibility)/1000)"
    }
}
