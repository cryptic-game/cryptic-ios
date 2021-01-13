//
//  Response.swift
//  cryptic
//
//  Created by Nils Grob on 09.01.21.
//

import Foundation

struct Response:Codable{
    let tag:String?
    var data:ResponseData?
    let token:String?
    let online:Int?
    let error:String?
    let status:String?
    let name:String?
    let uuid:UUID?
    let last:Double?
    
    
    
}

struct ResponseData:Codable{
    let devices:[DeviceModel]?
    let services:[ServiceModel]?
    let uuid:UUID?
    let name:String?
    let owner:UUID?
    let powered_on:Bool?
    let starter_device:Bool?
    let hardware:[Hardware]?
    let running:Bool?
    let error:String?

}

struct ServiceModel:Codable{
    let running:Bool?
    let owner:UUID?
    let running_port:Int?
    let name:String
    let uuid:UUID
    let device:UUID
    let speed:Double?
    let part_owner:UUID?
}
