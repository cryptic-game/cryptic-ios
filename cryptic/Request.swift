//
//  Request.swift
//  cryptic
//
//  Created by Nils Grob on 09.01.21.
//

import Foundation

struct MSRequest:Codable{
    let tag:UUID
    let ms:String
    let endpoint:[String]
    let data:MSData
}

struct MSData:Codable{
    let device_uuid:String?
}

struct DeviceRequest:Codable{
    let device_uuid:UUID?
}

