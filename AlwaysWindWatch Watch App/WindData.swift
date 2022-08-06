//
//  WindData.swift
//  AlwaysWindWatch Watch App
//
//  Created by Antoine Souben-Fink on 05/08/2022.
//

import Foundation

struct LiveWindData: Decodable {
    var wind_rt: wind_rt_Data
}

struct wind_rt_Data: Decodable {
    var date: Int
    var dir: Int
    var force: Float
}

struct AverageWindData: Decodable {
    var wind: wind_Data
}

struct wind_Data: Decodable {
    var dir_avg: Float
    var dir_max: Int
    var dir_min: Int
    var end_date: Int
    var force_avg: Float
    var force_min: Float
    var force_max: Float
    var start_date: Int
}
