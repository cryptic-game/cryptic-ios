//
//  Response.swift
//  cryptic
//
//  Created by Nils Grob on 09.01.21.
//

import Foundation

struct Response:Codable{
    let tag:String?
    let data:String?
    let token:String?
    let online:Int?
    let error:String?
    let status:String?
    
}
