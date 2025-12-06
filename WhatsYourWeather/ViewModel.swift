//
//  ViewModel.swift
//  WhatsYourWeather
//
//  Created by Sarubala on 30/01/24.
//

import Foundation
import CoreLocation
import UserNotifications

class ViewModel:NSObject, ObservableObject,CLLocationManagerDelegate{
    
    //location variables
    var locationManager=CLLocationManager()
    var lat:String?
    var lon:String?
    @Published var locationDesc:Location?
    var lastLocation: CLLocation?
    
    override init() {
        super.init()
        fetch()
    }
    
    func fetch(){
        print("fetch is called")
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 5000
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        print("fetch ends")
    }
    
    func checkForPermission(){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert,.sound]) { allowed, error in
                    if allowed{
                        self.dispatchLocalNotifications()
                    }
                }
            case .denied:
                return
            case .authorized:
                self.dispatchLocalNotifications()
            default:
                return
            }
        }
    }
    
    func dispatchLocalNotifications(){
        print("dispatching notifications")
        let identifier = "weather-alert"
        
        let content = UNMutableNotificationContent()
        content.title = "\(String(describing: locationDesc!.weather.first!.main)) in \(String(describing: locationDesc!.name))"
        content.body = "feels like \(String(describing: locationDesc!.main.feels_like))K"
        content.sound = .default
        
        let date = Date().addingTimeInterval(2)
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request)
        print("notification request added")
        
    }
    
     func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
         print("location manager is called")
         
        let userLocation: CLLocation = locations[0]
         
        lat=String(userLocation.coordinate.latitude)
        lon=String(userLocation.coordinate.longitude)

         let apikey = ApiKey.APIKEY//e
         let request = NSMutableURLRequest(url: NSURL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(String(describing: lat!))&lon=\(String(describing: lon!))&appid=\(apikey)")! as URL,
                                                 cachePolicy: .useProtocolCachePolicy,
                                             timeoutInterval: 100.0)
         request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {

                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    //for debugging
                    print("Response data string:\n \(dataString)")
                }
                do{
                    
                    let locationDesc = try JSONDecoder().decode(Location.self, from: data!)
                    DispatchQueue.main.async {
                        self.locationDesc=locationDesc
                        self.checkForPermission()
                    }
                }
                catch{
                    print(error)
                }
                
                
            }
        })

        dataTask.resume()
        
    }
    
    func kelvinToDegreeConvertor(temp:Double,num:String)->String{
            switch num{
            case "celcius":
                return String(round((temp - 273)*100)/100)+"°C"
                
            case "fahrenheit":
                return  String(round(((temp - 273.15) * 9/5 + 32)*100)/100)+"°F"
                
            default:
                return String(round(temp*100)/100)+"K"
            }
            
        }
}
