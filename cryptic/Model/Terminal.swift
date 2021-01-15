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
    var spotedDeviceName:String?
    var files:[FileModel] = []
    
    override init(socket:Socket) {
        self.viewModel = nil
        self.spotedDevice = nil
        self.spotedDeviceName = nil
        self.listServices = false
        super.init(socket: socket)
        
    }
    override func receive(data: ResponseData) {
        if(data.uuid != nil){
            if(data.uuid?.uuidString.lowercased() == defaults.string(forKey: "currentDevice")){
                return
            }
            if(data.filename != nil){
                files.append(FileModel(uuid: data.uuid!, device: data.device!, filename: data.filename!, content: data.content!, parent_dir_uuid: data.parent_dir_uuid == nil ? nil:data.parent_dir_uuid!, is_directory: data.is_directory!))
                return
            }
            if(data.running != nil){
                return
            }else{
                self.spotedDevice = data.uuid!.uuidString.lowercased()
                self.spotedDeviceName = data.name!
                self.listAllServices(deviceUUID: defaults.string(forKey: "currentDevice")!)
                
//                DispatchQueue.main.async {
//                    self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: "spot", output:"'\(data.name!)'\n\t• UUID: \(data.uuid!.uuidString.lowercased())"))
//                }
            }

        }else if(data.services != nil){

            if(data.services![0].device.uuidString.lowercased() == defaults.string(forKey: "currentDevice")){
                var rows:[Row] = []
                if(listServices){
                    rows.append(Row(id: UUID(), contentBeforeUUID: "'\(viewModel!.device)' (", uuid: defaults.string(forKey: "currentDevice")!, contentAfterUUID: "):"))
                    for service in data.services!{
                        if(service.running!){
                            rows.append(Row(id: UUID(), contentBeforeUUID: "\t • \(service.name) (Running,UUID:", uuid: "\(service.uuid.uuidString.lowercased())", contentAfterUUID: "Port: \(service.running_port!))"))
                        }else{
                            rows.append(Row(id: UUID(), contentBeforeUUID: "\t • \(service.name) (Offline,UUID:", uuid: "\(service.uuid.uuidString.lowercased())", contentAfterUUID: ")"))
                        }
                    }
                    self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: "service list", output:rows))
                    listServices = false
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
                        rows.append(Row(id: UUID(), contentBeforeUUID: "\t portscan failed", uuid: "", contentAfterUUID: ""))
                        self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: "spot", output:rows))
                    }else{
                        self.use(targetDevice: spotedDevice!, serviceUUID: portscan)
                    }
                }

                }else {
                var rows:[Row] = []
                    rows.append(Row(id: UUID(), contentBeforeUUID: "'\(spotedDeviceName!)'", uuid: "", contentAfterUUID: ""))
                    rows.append(Row(id: UUID(), contentBeforeUUID: "• UUID:", uuid: "\(spotedDevice!)", contentAfterUUID: ""))
                    rows.append(Row(id: UUID(), contentBeforeUUID: "• Services:", uuid: "", contentAfterUUID: ""))
                for service in data.services!{
                    if service.name == "ssh"{
                        rows.append(Row(id: UUID(), contentBeforeUUID: "\t◦ ssh", uuid: "\(service.uuid)", contentAfterUUID: ""))
                    }else if service.name == "telnet"{
                        rows.append(Row(id: UUID(), contentBeforeUUID: "\t◦ telnet", uuid: "\(service.uuid)", contentAfterUUID: ""))
                    }
                }
                self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: "spot", output:rows))
            }


        }else if(data.error != nil){
            if(data.error! == "already_own_this_service"){
                self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "Service has already been created", uuid: "", contentAfterUUID: "")]))
                self.viewModel!.input = ""
            }
        }else if(data.files != nil){
            if(data.files!.isEmpty){
                self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "", uuid: "", contentAfterUUID: "")]))
                self.viewModel!.input = ""
            }else{
                var rows:[Row] = []
                self.files.removeAll()
                for file in data.files!{
                    rows.append(Row(id: UUID(), contentBeforeUUID: file.filename, uuid: "", contentAfterUUID: ""))
                    self.files.append(file)
                }
                self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:rows))
                self.viewModel!.input = ""
            }
        }else{
            self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "An error occured", uuid: "", contentAfterUUID: "")]))
            self.viewModel!.input = ""
        }
    }
            
       
    func spot()  {
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "spot"], data:MSData(device_uuid:nil, name: nil, service_uuid: nil, target_device: nil, parent_dir_uuid: "", filename: nil, is_directory:nil,content:nil)))
            print(String(data: req, encoding: .utf8)!)

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
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["list"], data:MSData(device_uuid: deviceUUID, name: nil, service_uuid: nil, target_device: nil, parent_dir_uuid: "", filename: nil, is_directory:nil,content:nil)))
            print(String(data: req, encoding: .utf8)!)
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
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["use"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice")!,name: nil, service_uuid: serviceUUID, target_device: targetDevice, parent_dir_uuid: "", filename: nil, is_directory:nil,content:nil)))
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
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "change_name"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: new, service_uuid: nil, target_device: nil,parent_dir_uuid: "", filename: nil, is_directory:nil,content:nil)))
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
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["create"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: name,service_uuid: nil, target_device: nil, parent_dir_uuid: "",filename: nil, is_directory:nil,content:nil)))
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
    func list(parent_dir:String?){
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["file", "all"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: nil,service_uuid: nil, target_device: nil,parent_dir_uuid: parent_dir, filename: nil, is_directory:nil,content:nil )))
            print(String(data: req, encoding: .utf8)!)
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
    func touch(name:String, content:String, parent_dir:String?){
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["file", "create"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: nil,service_uuid: nil, target_device: nil,parent_dir_uuid: parent_dir, filename: name, is_directory:false, content:content )))
            print(String(data: req, encoding: .utf8)!)
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
    
    func cat(name:String){
        for file in self.files{
            if(file.filename == name){
                if(file.is_directory){
                    self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "That is not a file", uuid: "", contentAfterUUID: "")]))
                    self.viewModel!.input = ""
                    return 
                }else{
                    self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: file.content, uuid: "", contentAfterUUID: "")]))
                    self.viewModel!.input = ""
                    return
                }
                
            }
        }
        self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "That file does not exist", uuid: "", contentAfterUUID: "")]))
        self.viewModel!.input = ""
    }
    
    func mkdir(name:String, parent_dir:String?){
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["file", "create"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: nil,service_uuid: nil, target_device: nil,parent_dir_uuid: parent_dir, filename: name, is_directory:true, content:"" )))
            print(String(data: req, encoding: .utf8)!)
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
}
