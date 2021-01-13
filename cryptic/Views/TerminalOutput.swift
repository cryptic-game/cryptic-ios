//
//  TerminalOutput.swift
//  cryptic
//
//  Created by Nils Grob on 11.01.21.
//

import Foundation

struct TerminalOutput:Identifiable{
    let id: UUID
    let username:String
    let deviceName:String
    let path:String
    let command:String
    var output:[Row]
    
    
}

struct Row:Identifiable{
    let id:UUID
    let contentBeforeUUID:String
    let uuid:String
    let contentAfterUUID:String
}
