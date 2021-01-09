//
//  Credentials.swift
//  cryptic
//
//  Created by Nils Grob on 07.01.21.
//

import Foundation

struct loginCredentials:Codable{
    let action:String
    let name:String
    let password:String
}

struct Response:Codable{
    let tag:String?
    let data:String?
    let token:String?
    let online:Int?
    let error:String?
    let status:String?
    
}

struct registerCredentials:Codable{
    let action:String
    let name:String
    let password:String
}

struct Logout:Codable{
    let action:String
}
