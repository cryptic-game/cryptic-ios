//
//  Terminal.swift
//  cryptic
//
//  Created by Nils Grob on 12.01.21.
//

import Foundation

class Terminal:Model{
    let defaults = UserDefaults.standard
    var viewModel:TerminalViewModel?
    
    override init(socket:Socket) {
        self.viewModel = nil
        super.init(socket: socket)
        
    }
    override func receive(data: ResponseData) {
        
    }
    
    func changeHost(new:String){
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "change_name"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: new)))
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
}
