import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    
    var body: some View {
        VStack {
            Image(systemName: "\(viewModel.weatherIcon)")
                .font(.system(size: 60.0, weight: .bold))
                .padding()
            Text(viewModel.cityName)
                .font(.largeTitle)
                .padding()
            HStack {
                Spacer()
                Text(viewModel.temperature)
                    .font(.system(size: 40))
                    .bold()
                Spacer()
                Text("|")
                    .font(.system(size: 50))
                Spacer()
                Text(viewModel.weatherDescription).font(.system(size: 25))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.all)
                Spacer()
            }
            Divider()
            Spacer()
            //additional features of weather
            VStack {
                //upper features StackView
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "humidity.fill")
                            .font(.system(size: 30.0, weight: .bold))
                            .foregroundColor(.yellow)
                        Text("\(viewModel.humidity) %")
                            .font(.system(size: 20))
                        
                    }
                    Spacer()
                    VStack {
                        //visibility
                        Image(systemName: "binoculars")
                            .font(.system(size: 30.0, weight: .bold)).foregroundColor(.yellow)
                        Text("\(viewModel.visibility) km")
                            .font(.system(size: 20))
                        
                    }
                    Spacer()
                    VStack {
                        //pressure
                        Image(systemName: "thermometer")
                            .font(.system(size: 30.0, weight: .bold)).foregroundColor(.yellow)
                        Text("\(viewModel.pressure) hPa")
                            .font(.system(size: 20))
                        
                    }
                    Spacer()
                }
                Spacer()
                //bottom features StackView
                HStack {
                    Spacer()
                    VStack {
                        //wind
                        Image(systemName: "wind")
                            .font(.system(size: 30.0, weight: .bold)).foregroundColor(.yellow)
                        Text("\(viewModel.windSpeed) km/h")
                            .font(.system(size: 20))
                        
                    }
                    Spacer()
                    VStack {
                        //wind degree
                        Image(systemName: "safari")
                            .font(.system(size: 30.0, weight: .bold)).foregroundColor(.yellow)
                        Text("\(viewModel.windDegree) degrees")
                            .font(.system(size: 20))
                        
                    }
                    Spacer()
                }
                Spacer()
                Spacer()
            }
            //Share button
            //            Button(action: shareButton) {
            //                Text("Share")
            //
            //                    }
            //navigation buttons
            
            HStack {
                Spacer()
                NavigationLink(destination: WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))) {
                    VStack {
                        Image(systemName: "sun.max")
                            .font(.system(size: 25.0, weight: .bold))
                        Text("Today")
                            .font(.system(size: 20))
                    }
                }
                Spacer()
                NavigationLink(destination: ForecastView(forecastVM: ForecastWeatherViewModel(forecastWeatherService: ForecastWeatherService()))) {
                    VStack {
                        Image(systemName: "cloud.moon.bolt")
                            .font(.system(size: 25.0, weight: .bold))
                        Text("Forecast")
                            .font(.system(size: 20))
                    }
                }
                Spacer()
            }
        }
        .padding(.all)
        .alert(isPresented: $viewModel.shouldShowLocationError) {
            Alert(
                title: Text("Error"),
                message: Text("To see the weather, provide location access in Settings."),
                dismissButton:
                        .default(Text("Open Settings")) {
                            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                            UIApplication.shared.open(settingsURL)
                        }
            )
        }
        .onAppear(perform: viewModel.refresh)
    }
}
//func shareButton() {
//    let activityViewController = UIActivityViewController(activityItems: [viewModel.weatherDescription], applicationActivities: nil)
//    UIApplication.shared.windows.first?.rootViewController?.present(activityViewController: true, completion: nil)
//
//}

//SecondView 
//struct ForecastWeatherView: View {
//    var body: some View {
//        Text("Hello, World!")
//    }
//}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
        ForecastView(forecastVM: ForecastWeatherViewModel(forecastWeatherService: ForecastWeatherService()))
    }
}
