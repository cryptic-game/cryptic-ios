//
//  Device.swift
//  cryptic
//
//  Created by Nils Grob on 09.01.21.
//

import Foundation

class Device:Model{
    var viewModel:DashboardViewModel?
    
    override init(socket:Socket) {
        self.viewModel = nil
        super.init(socket: socket)
        
    }
    override func receive(data: ResponseData) {
        for device in data.devices!{
            //To Do. get info of all devices
            print(device)
        }
        DispatchQueue.main.async {
            self.viewModel?.device = data.devices![0]
            self.viewModel?.isLoading = false
        }
        
    }
    
    func getAll() -> (){
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "all"], data:MSData(data: nil)))
            print(String(data: req, encoding: .utf8)!)
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
    
    func getInfo(){
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "info"], data:MSData(data: nil)))
            print(String(data: req, encoding: .utf8)!)
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
}
