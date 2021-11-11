import Foundation

public struct ForecastWeather {
    let city: String
    let temperature: Int
    let description: String
    let iconName: String
    let dateTime: String
    
    init(response: APIForecastResponse) {
        city = response.list.first?.city.name ?? ""
        temperature = Int((response.list.first?.main.temp ?? 0))
        description = response.list.first?.weather.first?.description ?? ""
        iconName = response.list.first?.weather.first?.iconName ?? ""
        dateTime = response.list.first?.dt_txt ?? ""
        //                        Image("\(self.forecastVM.forecastResponse.list.first?.weather.first?.iconName)")
    }
}




