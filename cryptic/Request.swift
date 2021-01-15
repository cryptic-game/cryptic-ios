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

enum CodingKeys: CodingKey {
  case device_uuid, name, service_uuid, target_device, parent_dir_uuid, filename, is_directory, content
}
struct MSData:Codable{
    let device_uuid:String?
    let name:String?
    let service_uuid:String?
    let target_device:String?
    var parent_dir_uuid:String?
    let filename:String?
    let is_directory:Bool?
    let content:String?
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(device_uuid, forKey: .device_uuid)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(service_uuid, forKey: .service_uuid)
        try container.encodeIfPresent(target_device, forKey: .target_device)
        try container.encodeIfPresent(filename , forKey: .filename)
        try container.encodeIfPresent(is_directory, forKey: .is_directory)
        try container.encodeIfPresent(content, forKey: .content)
        switch parent_dir_uuid {
        case .some(let value):if(value == ""){return}else{ try container.encode(value, forKey: .parent_dir_uuid)}
        case .none: try container.encodeNil(forKey: .parent_dir_uuid)
        }
    }
}

struct DeviceRequest:Codable{
    let device_uuid:UUID?
}

