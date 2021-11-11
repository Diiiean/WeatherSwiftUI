import SwiftUI
struct ForecastView: View {
    @ObservedObject var forecastVM: ForecastWeatherViewModel
    var body: some View {
        NavigationView {
            List(self.forecastVM.forecastResponse.list, id: \.dt) { forecast in
                VStack {
                    HStack {
                        //Weather Icon
                        Image(systemName: "\(forecastVM.weatherIcon)")  .font(.system(size: 22.0, weight: .bold)) .padding()
                        //Date properly, city name, hours, description
                        VStack {
                            //city name
                            Text("\(forecastVM.dateFormatter(timeStamp: forecast.dt))").font(.footnote)
                            Text("\(forecastVM.getTime(timeStamp: forecast.dt))")
                            
                            Text("\(forecastVM.cityName)")
                            Text("\(forecastVM.weatherDescription)")
                            
                        }
                        //weather temp
                        Text("\(forecastVM.temperature)")
                        
                        
                    }
                }
            }
        }
        .onAppear(perform: forecastVM.refresh)
    }
}

struct ForecastViewController_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(forecastVM: ForecastWeatherViewModel(forecastWeatherService: ForecastWeatherService()))
        //WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
    }
}

