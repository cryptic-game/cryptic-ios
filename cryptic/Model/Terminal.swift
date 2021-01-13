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
    var listServices:Bool
    var spotedDevice:String?
    
    override init(socket:Socket) {
        self.viewModel = nil
        self.spotedDevice = nil
        self.listServices = false
        super.init(socket: socket)
        
    }
    override func receive(data: ResponseData) {
        if(data.uuid != nil){
            if(data.running != nil){
                return 
            }else{
                self.spotedDevice = data.uuid!.uuidString.lowercased()
                self.listAllServices(deviceUUID: defaults.string(forKey: "currentDevice")!)
                DispatchQueue.main.async {
                    self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: "spot", output:"'\(data.name!)'\n\t• UUID: \(data.uuid!.uuidString.lowercased())"))
                }
            }
            
        }else if(data.services != nil){
            
            if(data.services![0].device.uuidString.lowercased() == defaults.string(forKey: "currentDevice")){
                if(listServices){
                    self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: "service list", output:"'\(viewModel!.device)' (" + defaults.string(forKey: "currentDevice")! + "):"))
                    for service in data.services!{
                        if(service.running!){
                            self.viewModel!.output[viewModel!.output.count - 1].output.append("\n\t • \(service.name) (Running UUID: \(service.uuid.uuidString.lowercased()) Port: \(service.running_port!)")
                        }else{
                            self.viewModel!.output[viewModel!.output.count - 1].output.append("\n\t • \(service.name) (Offline UUID: \(service.uuid.uuidString.lowercased()))")
                        }
                        listServices = false
                    }
                }else{
                    var portscanOn:Bool = false
                    var portscan:String = ""
                    for service in data.services!{
                        if(service.name == "portscan"){
                            portscanOn = true
                            portscan = service.uuid.uuidString.lowercased()
                        }
                    }
                    if(!portscanOn){
                        self.viewModel!.output[viewModel!.output.count - 1].output.append("\n\t portscan failed")
                    }else{
                        self.use(targetDevice: spotedDevice!, serviceUUID: portscan)
                    }
                }
                
            }else {
                self.viewModel!.output[viewModel!.output.count - 1].output.append("\n • Services:")
                for service in data.services!{
                    if service.name == "ssh"{
                        self.viewModel!.output[viewModel!.output.count - 1].output.append("\n\t◦ ssh(\(service.uuid))")
                    }else if service.name == "telnet"{
                        self.viewModel!.output[viewModel!.output.count - 1].output.append("\n\t◦ telnet(\(service.uuid))")
                    }
                }
                
            }
        
            
        }else if(data.error != nil){
            if(data.error! == "already_own_this_service"){
                self.viewModel!.output[viewModel!.output.count - 1].output.append("Service has already been created")
            }
        }else{
            DispatchQueue.main.async {
                self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: self.viewModel!.input, output:"An error occured"))
            }
        }
    }
    func spot()  {
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "spot"], data:MSData(device_uuid:nil, name: nil, service_uuid: nil, target_device: nil)))
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
    
    func listAllServices(deviceUUID:String){
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["list"], data:MSData(device_uuid: deviceUUID, name: nil, service_uuid: nil, target_device: nil)))
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
    
    func use(targetDevice:String, serviceUUID:String) {
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["use"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice")!,name: nil, service_uuid: serviceUUID, target_device: targetDevice)))
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
    func changeHost(new:String){
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "change_name"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: new, service_uuid: nil, target_device: nil)))
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
    
    func create(name:String){
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["create"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: name,service_uuid: nil, target_device: nil)))
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
}
