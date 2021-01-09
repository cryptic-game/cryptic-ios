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

struct registerCredentials:Codable{
    let action:String
    let name:String
    let password:String
}

struct Logout:Codable{
    let action:String
}

struct LoginToken:Codable{
    let action:String
    let token:String
}
