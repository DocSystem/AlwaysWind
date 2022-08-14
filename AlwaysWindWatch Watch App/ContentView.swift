//
//  ContentView.swift
//  AlwaysWindWatch Watch App
//
//  Created by Antoine Souben-Fink on 05/08/2022.
//

import SwiftUI

struct ContentView: View {
    @State var liveData = LiveWindData(wind_rt: wind_rt_Data(date: 0, dir: 0, force: 0.0))
    @State var averageData = AverageWindData(wind: wind_Data(dir_avg: 0.0, dir_max: 0, dir_min: 0, end_date: 0, force_avg: 0.0, force_min: 0.0, force_max: 0.0, start_date: 0))
    
    func getLiveData() {
        let urlString = "https://data.diabox.com/dataUpdate.php?dbx_id=108&dataNameList%5B%5D=wind_rt"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) {data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(LiveWindData.self, from: data)
                        self.liveData = decodedData
                    } catch {
                        print("Error! Something went wrong")
                    }
                }
            }
        }.resume()
    }
    
    func getAverageData() {
        let urlString = "https://data.diabox.com/recentDataAverage.php?dbx_id=108&dataNameList%5B%5D=wind"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) {data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(AverageWindData.self, from: data)
                        self.averageData = decodedData
                    } catch {
                        print("Error! Something went wrong")
                    }
                }
            }
        }.resume()
    }
    
    func calcForce(windSpeed: Float)->Int {
        if (windSpeed < 0.5) {return 0}
        else if (windSpeed < 3) {return 1}
        else if (windSpeed < 6) {return 2}
        else if (windSpeed < 10) {return 3}
        else if (windSpeed < 14) {return 4}
        else if (windSpeed < 19.5) {return 5}
        else if (windSpeed < 25) {return 6}
        else if (windSpeed < 31) {return 7}
        else if (windSpeed < 37.5) {return 8}
        else if (windSpeed < 44.5) {return 9}
        else if (windSpeed < 51.5) {return 10}
        else if (windSpeed <= 60) {return 11}
        else {return 12}
    }
    
    func calcWindDir(windDegree: Int)-> String {
        if (windDegree < 28) {return "N"}
        else if (windDegree < 73) {return "NE"}
        else if (windDegree < 118) {return "E"}
        else if (windDegree < 163) {return "SE"}
        else if (windDegree < 208) {return "S"}
        else if (windDegree < 253) {return "SO"}
        else if (windDegree < 298) {return "O"}
        else if (windDegree < 343) {return "NO"}
        else {return "N"}
    }
    
    func getColorByWindForce(windForce: Int)->Color {
        switch (windForce) {
        case 0:
            return .primary
        case 1:
            return .green
        case 2:
            return .yellow
        case 3:
            return .cyan
        case 4:
            return .blue
        case 5:
            return .indigo
        case 6:
            return .brown
        case 7:
            return .orange
        case 8:
            return .red
        case 9:
            return .purple
        case 10:
            return .gray
        case 11:
            return .gray
        case 12:
            return .gray
        default:
            return .primary
        }
    }
    
    var body: some View {
        let liveWindSpeed = String(format: "%.1f", liveData.wind_rt.force)
        let liveWindForce = self.calcForce(windSpeed: liveData.wind_rt.force)
        let averageWindSpeed = String(format: "%.1f", averageData.wind.force_avg)
        let averageWindForce = self.calcForce(windSpeed: averageData.wind.force_avg)
        let averageWindDirection = String(format: "%.1f", averageData.wind.dir_avg)
        let liveTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
        let averageTimer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
        TabView {
            VStack {
                Spacer()
                Image(systemName: "arrow.down")
                    .font(.title)
                    .rotationEffect(Angle(degrees: Double(liveData.wind_rt.dir)))
                Text("\(liveData.wind_rt.dir)° \(self.calcWindDir(windDegree: liveData.wind_rt.dir))")
                    .font(.title3)
                Spacer()
                Text("\(liveWindSpeed) nœuds")
                    .font(.title2)
                Text("Force \(liveWindForce)")
                    .font(.title3)
                    .foregroundColor(getColorByWindForce(windForce: liveWindForce))
                Spacer()
            }
                .onAppear(perform: self.getLiveData)
                .onReceive(liveTimer) {_ in
                    self.getLiveData()
                }
            VStack {
                Spacer()
                Image(systemName: "arrow.down")
                    .font(.title)
                    .rotationEffect(Angle(degrees: Double(averageData.wind.dir_avg)))
                Text("\(averageWindDirection)° \(self.calcWindDir(windDegree: Int(averageData.wind.dir_avg)))")
                    .font(.title3)
                Spacer()
                Text("\(averageWindSpeed) nœuds")
                    .font(.title2)
                Text("Force \(averageWindForce)")
                    .font(.title3)
                    .foregroundColor(getColorByWindForce(windForce: averageWindForce))
                Spacer()
            }
                .onAppear(perform: self.getAverageData)
                .onReceive(averageTimer) {_ in
                    self.getAverageData()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
