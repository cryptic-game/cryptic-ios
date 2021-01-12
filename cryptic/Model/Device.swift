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
        if(data.devices != nil){
            DispatchQueue.main.async {
                self.viewModel?.device = data.devices![0]
                self.viewModel?.isLoading = false
            }
            for device in data.devices!{
                //To Do. get info of all devices
                getInfo(device_uuid: device.uuid)
                print(device)
            }
        }
        if(data.hardware != nil){
            let device = DeviceModel(uuid: data.uuid!, name: data.name!, owner: data.owner!, powered_on: data.powered_on!, starter_device: data.powered_on!, hardware: data.hardware!)
            DispatchQueue.main.async {
                self.viewModel?.device = device
                self.viewModel?.isLoading = false
            }
        }
        
        
    }
    
    func getAll() -> (){
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "all"], data:MSData(device_uuid: nil)))
            print(String(data: req, encoding: .utf8)!)
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
    
    func getInfo(device_uuid:UUID){
        do {
            let uuid = UUID()
            //let data = try encoder.encode(DeviceRequest(device_uuid: device_uuid))
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "info"], data:MSData(device_uuid: device_uuid.uuidString.lowercased())))
            print(String(data: req, encoding: .utf8)!)
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
}
