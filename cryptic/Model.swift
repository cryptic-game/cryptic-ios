//
//  Model.swift
//  cryptic
//
//  Created by Nils Grob on 08.01.21.
//

import Foundation

class Model{
    var socket:Socket
    let encoder = JSONEncoder()
    
    init(socket:Socket) {
        self.socket = socket
    }
    func login(credentials:loginCredentials){
        do {
            let data = try encoder.encode(credentials)
            socket.connection.write(string: String(data: data, encoding: .utf8)!)
        }catch let error {
            print("[WEBSOCKET] Error serializing JSON:\n\(error)")
            
        }
    }
    
    func register(credentials:registerCredentials){
        do {
            let data = try encoder.encode(credentials)
            socket.connection.write(string: String(data: data, encoding: .utf8)!)
        }catch let error {
            print("[WEBSOCKET] Error serializing JSON:\n\(error)")
            
        }
    }
}
