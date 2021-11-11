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

class ForecastWeatherViewModel: ObservableObject {
      @Published var cityName: String = "City Name"
      @Published var temperature: String = "--"
      @Published var weatherDescription: String = "--"
      @Published var weatherIcon: String = defaultIcon
      @Published var dt_txt: Int = 0
      @Published var shouldShowLocationError: Bool = false
      @Published var forecastResponse = APIForecastResponse.init(list: [], city: City())
      
    public let forecastWeatherService: ForecastWeatherService

    init(forecastWeatherService: ForecastWeatherService) {
        self.forecastWeatherService = forecastWeatherService
        
    }
      
    func refresh() {
        forecastWeatherService.loadWeatherData { weather, error in
            DispatchQueue.main.async {
                if let _ = error {
                    self.shouldShowLocationError = true
                    return
                }

                self.shouldShowLocationError = false
                guard let forecastWeather = weather else { return }
                self.cityName = forecastWeather.city
                self.temperature = "\(forecastWeather.temperature)ºC"
                self.weatherDescription = forecastWeather.description.capitalized
               self.weatherIcon = iconMap[forecastWeather.iconName] ?? defaultIcon
                self.dt_txt = Int(forecastWeather.dateTime) ?? 0
                
                
            }
        }
    }
                /// Format the date properly (e.g. Monday, May 11, 2020)
                    public func dateFormatter(timeStamp: Int) -> String {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .full
                        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
                    }
                /// The the current time in 12-hour format with the right timezone with the am/pm (e.g. 5:52)
                  public func getTime(timeStamp: Int) -> String {
                      let formatter = DateFormatter()
                      formatter.dateFormat = "h:mm a"
                      formatter.timeZone = TimeZone(secondsFromGMT: self.forecastResponse.city.timezone ?? 0)
                      return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
                  }
                  /// Get the city name
                  var city: String {
                      if let city = self.forecastResponse.city.name {
                          return city
                      }
                      return ""
                  }
}
