import Foundation

private let defaultIcon = "--"
private let iconMap = [
    "Drizzle" : "cloud.drizzle",
    "Thunderstorm" : "cloud.bolt",
    "Rain": "cloud.rain",
    "Snow": "cloud.snow",
    "Clear": "sun.max",
    "Clouds" : "cloud",
]

class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "City Name"
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = "--"
    @Published var pressure: String = "--"
    @Published var humidity: String = "--"
    @Published var windSpeed: String = "--"
    @Published var windDegree: String = "--"
    @Published var visibility: String = "--"
    @Published var weatherIcon: String = defaultIcon
    @Published var shouldShowLocationError: Bool = false
    
    public let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func refresh() {
        weatherService.loadWeatherData { weather, error in
            DispatchQueue.main.async {
                if let _ = error {
                    self.shouldShowLocationError = true
                    return
                }
                
                self.shouldShowLocationError = false
                guard let weather = weather else { return }
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)ºC"
                self.weatherDescription = weather.description.capitalized
                self.pressure = weather.pressure
                self.humidity = weather.humidity
                self.windSpeed = weather.speed
                self.visibility = weather.visibility
                self.windDegree = weather.windDegree
                self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
            }
        }
    }
}
