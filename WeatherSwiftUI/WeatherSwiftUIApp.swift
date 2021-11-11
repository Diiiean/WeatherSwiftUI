import SwiftUI

@main
struct WeatherApp: App {
  var body: some Scene {
    WindowGroup {
      let weatherService = WeatherService()
      WeatherView(viewModel: WeatherViewModel(weatherService: weatherService))
        
//      let forecastService = ForecastWeatherService()
//      ForecastView(forecastVM: ForecastWeatherViewModel(forecastWeatherService: forecastService))
    }
  }
}
