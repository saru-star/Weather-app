//
//  LocationDataModel.swift
//  WhatsYourWeather
//
//  Created by Sarubala on 30/01/24.
//

import Foundation

struct Location: Codable,Hashable{
    var coord: Coord
    var weather: [Weather]
    var base: String
    var main: Main
    var visibility: Int
    var wind: Wind
    var rain: Rain?
    var clouds: Clouds
    var dt: Int
    var sys: Sys
    var timezone, id: Int
    var name: String
    var cod: Int
}

struct Clouds:Codable,Hashable {
    var all: Int
}

struct Coord :Codable,Hashable{
    var lon, lat: Double
}

struct Main :Codable,Hashable{
    var temp:Double
    var feels_like:Double
    var temp_min:Double
    var temp_max: Double
    var pressure, humidity: Int
}

struct Rain :Codable,Hashable{
    
    var the1H: Double?
}

struct Sys :Codable,Hashable{
    var type, id: Int
    var country: String
    var sunrise, sunset: Int
}

struct Weather :Codable,Hashable{
    var id: Int
    var main, description, icon: String
}

struct Wind :Codable,Hashable{
    var speed: Double
    var deg: Int
}
