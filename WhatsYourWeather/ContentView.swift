//
//  ContentView.swift
//  WhatsYourWeather
//
//  Created by Sarubala on 22/01/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject var viewmodel=ViewModel()
    
    @State private var selectedUnit = "celcius"
    let units = ["celcius", "kelvin", "fahrenheit"]
    
    var body:some View{
        let location=viewmodel.locationDesc
        ZStack{
            
            VStack{
                Text("Weather Today").font(Font.largeTitle.lowercaseSmallCaps()).font(.headline).fontWeight(.heavy).multilineTextAlignment(.center).padding(.top)
                    .foregroundColor(.black)
                Divider()
                Spacer()
                
                HStack{
                    
                    Text(String(location != nil ? location!.name:"Location"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.leading, 10.0)
                    Spacer()
                }
                Spacer()
                if let location=viewmodel.locationDesc {
                    let url = URL(string: "https://openweathermap.org/img/wn/\(location.weather.first!.icon)@4x.png")
                    AsyncImage(url: url) { myImg in
                        myImg.image?.resizable()
                            .frame(width: 200,height: 200)
                    }
                    
                }else{
                    Image("myImage")
                }
                
                Text(String(location != nil ? location!.weather.first!.main :"Weather"))
                    .font(.title)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 4.0)
                
                Text(location != nil ? location!.weather.first!.description :"Description")
                    .font(.body)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                
                Spacer()
                Divider()
                HStack{
                    DisclosureGroup(String("Temperature \(location != nil ? ":\(viewmodel.kelvinToDegreeConvertor(temp: location!.main.temp, num: selectedUnit))" :"")")) {
                        HStack{
                            Spacer()
                            Picker("Pick a unit", selection: $selectedUnit) {
                                ForEach(units, id: \.self) {
                                    Text($0)
                                }
                            }
                            .background(.teal)
                            .font(.title3)
                            .accentColor(.white)
                            .cornerRadius(12)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                        }
                        HStack {
                            Text("Min Temp: \(location != nil ? "\(viewmodel.kelvinToDegreeConvertor(temp: location!.main.temp_min, num: selectedUnit))" :"")")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            Text("Max Temp: \(location != nil ? "\(viewmodel.kelvinToDegreeConvertor(temp: location!.main.temp_max, num: selectedUnit))" :"")")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(Color.black)
                            
                            Spacer()
                        }
                    }.padding()
                        .font(.title2)
                        .foregroundColor(.teal)
                    
                }
                Divider()
                DisclosureGroup("Atmosphere") {
                    VStack {
                        HStack{
                            
                            Text("Pressure: \(location != nil ? String(round(Double(location!.main.pressure*100))/100) :"")")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(Color.black)
                            Spacer()
                            
                            Text("Humidity: \(location != nil ? String(round(Double(location!.main.humidity*100))/100) :"")")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(Color.black)
                            
                            Spacer()
                        }
                        Spacer()
                        HStack{
                            
                            Text("Visibility: \(location != nil ? String(round(Double(location!.visibility*100)/100)) :"")")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(Color.black)
                            
                            Spacer()
                            
                            Text("WindSpeed: \(location != nil ? String(round(location!.wind.speed*100)/100) :"")")
                                .font(.body)
                                .fontWeight(.regular)
                                .foregroundColor(Color.black)
                            
                            Spacer()
                        }
                        Spacer()
                        
                    }
                }.padding()
                    .font(.title2)
                    .foregroundColor(.teal)
            }
        }
    }
    
    
          
}

    
//struct ContentView_Previews:PreviewProvider{
//    static var previews:some View{
//        ContentView()
//    }
//}

