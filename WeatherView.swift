import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "\(viewModel.weatherIcon)")
                .font(.system(size: 66.0, weight: .bold))
                .padding()
            Text(viewModel.cityName)
                .font(.largeTitle)
                .padding()
            HStack {
                Spacer()
                Text(viewModel.temperature)
                    .font(.system(size: 60))
                    .bold()
                Spacer()
                Text("|").font(.system(size: 60))
                Spacer()
                Text(viewModel.weatherDescription).font(.system(size: 35)).padding(.all)
                Spacer()
            }
            Divider()
            Spacer()
            //additional components of weather
            VStack {
                //1 row of pic
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "humidity.fill").font(.system(size: 36.0, weight: .bold)).foregroundColor(.yellow)
                        Text("\(viewModel.humidity) %")
                    }
                    Spacer()
                    VStack {
                        //visibility
                        Image(systemName: "binoculars").font(.system(size: 36.0, weight: .bold)).foregroundColor(.yellow)
                        Text("\(viewModel.visibility) km")
                    }
                    Spacer()
                    VStack {
                        //pressure
                        Image(systemName: "thermometer").font(.system(size: 36.0, weight: .bold)).foregroundColor(.yellow)
                        Text("\(viewModel.pressure) hPa")
                    }
                    Spacer()
                }
                Spacer()
                //2 row of pic
                HStack {
                    Spacer()
                    VStack {
                        //wind
                        Image(systemName: "wind").font(.system(size: 36.0, weight: .bold)).foregroundColor(.yellow)
                        Text("\(viewModel.windSpeed) km/h")
                    }
                    Spacer()
                    VStack {
                        //wind degree
                        Image(systemName: "safari").font(.system(size: 36.0, weight: .bold)).foregroundColor(.yellow)
                        Text("\(viewModel.windDegree) degrees")
                    }
                    Spacer()
                }
                Spacer()
                Spacer()
            }
            //bottom buttons
            HStack{
                Spacer()
                NavigationLink(destination: WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))) {
                    VStack {
                        Image(systemName: "sun.max").font(.system(size: 25.0, weight: .bold)).foregroundColor(.black)
                        Text("Today").foregroundColor(.black)
                    }
                }
                Spacer()
                NavigationLink(destination: ForecastWeatherView()) {
                    VStack {
                        Image(systemName: "cloud.moon.bolt").font(.system(size: 25.0, weight: .bold)).foregroundColor(.black)
                        Text("Forecast").foregroundColor(.black)
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
                dismissButton: .default(Text("Open Settings")) {
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(settingsURL)
                }
            )
        }
        .onAppear(perform: viewModel.refresh)
    }
}
//SecondView 
struct ForecastWeatherView: View {
    var body: some View {
        Text("Hello, World!")
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
    }
}
