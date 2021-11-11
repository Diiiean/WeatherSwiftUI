import CoreLocation
import Foundation


public final class ForecastWeatherService: NSObject {

    private let locationManager = CLLocationManager()
    private let API_KEY = "b724086411c606c9543ac631c7fa9bf0"
    private var completionHandler: ((ForecastWeather?, ForecastLocationAuthError?) -> Void)?
    private var dataTask: URLSessionDataTask?

    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData(
        _ completionHandler: @escaping((ForecastWeather?, ForecastLocationAuthError?) -> Void)
    ) {
        self.completionHandler = completionHandler
        loadDataOrRequestLocationAuth()
    }
    
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString =
                
                "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        
        // Cancel previous task
        dataTask?.cancel()
        
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            
            if let response = try? JSONDecoder().decode(APIForecastResponse.self, from: data) {
                self.completionHandler?(ForecastWeather(response: response), nil)
            }
        }
        dataTask?.resume()
    }
    
    private func loadDataOrRequestLocationAuth() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            completionHandler?(nil, ForecastLocationAuthError())
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension ForecastWeatherService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        makeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        loadDataOrRequestLocationAuth()
    }
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}


public struct APIForecastResponse: Decodable {
    var list: [ForecastList]
    var city: City
    
}

public struct ForecastList: Decodable {
    var dt: Int
    var main: APIForecastMain
    var weather: [APIForecastWeather]
    var city: APICity
    var dt_txt: String
}
public struct APIForecastMain: Decodable {
    var temp: Double
}
/// 'city' object for the forecast model.
public struct City: Decodable {
    var name: String?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
    var timezone: Int?
}
public struct APICity: Decodable {
    var name: String
}
public struct APIForecastWeather: Decodable {
    var description: String
    var iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
        
    }
}

public struct ForecastLocationAuthError: Error {}

