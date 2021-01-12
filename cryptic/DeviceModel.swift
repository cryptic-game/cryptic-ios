//
//  DeviceModel.swift
//  cryptic
//
//  Created by Nils Grob on 09.01.21.
//

import Foundation

struct DeviceModel:Codable {
    let uuid:UUID
    let name:String
    let owner:UUID
    let powered_on:Bool
    let starter_device:Bool
    let hardware:[Hardware]?
    
}

struct Hardware:Codable{
    let uuid:UUID
    let device_uuid:UUID
    let hardware_element:String
    let hardware_type:String
}
