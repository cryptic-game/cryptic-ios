//
//  Device.swift
//  cryptic
//
//  Created by Nils Grob on 09.01.21.
//

import Foundation

class Device:Model{
    
    override func receive(data: String) {
        print("\(data)")
        print("Decode this shit")
    }
    
    func getAll() -> (){
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: "device/all", data:nil))
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
}
