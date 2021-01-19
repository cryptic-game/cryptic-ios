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
    var spotDevices:Bool
    var listFiles:Bool
    var doBruteforce:Bool
    var spotedDevice:String?
    var spotedDeviceName:String?
    var files:[FileModel] = []
    var connectedDevices:[String] = []
    var bruteforceService:String = ""
    var connectToDevice:Bool
    var connected:Bool
    
    override init(socket:Socket) {
        self.viewModel = nil
        self.spotedDevice = nil
        self.spotedDeviceName = nil
        self.listServices = false
        self.doBruteforce = false
        self.listFiles = false
        self.spotDevices = false
        self.connectToDevice = false
        self.connected = false
        self.connectedDevices.append(defaults.string(forKey: "currentDevice")!)
        super.init(socket: socket)
        
    }
    override func receive(data: ResponseData) {
        if(data.uuid != nil){
            if(data.uuid?.uuidString.lowercased() == defaults.string(forKey: "currentDevice")){
                return
            }
            if(data.name != nil){
                if(connected){
                    self.viewModel?.remoteConnection = true
                    self.viewModel?.device = data.name!
                    self.viewModel?.input = ""
                    defaults.setValue(data.uuid!.uuidString.lowercased(), forKey: "currentDevice")
                    connectedDevices.append(data.uuid!.uuidString.lowercased())
                    connected = false
                }else if(connectToDevice){
                    if(data.owner!.uuidString.lowercased() == defaults.string(forKey: "userUUID")!){
                        self.viewModel?.remoteConnection = false
                        defaults.setValue(data.uuid!.uuidString.lowercased(), forKey: "currentDevice")
                        self.viewModel?.device = data.name!
                        self.viewModel?.input = ""
                    }
                }
                connectToDevice = false
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
                        if service.name == "bruteforce"{
                            self.bruteforceService = service.uuid.uuidString.lowercased()
                        }
                        if(service.name == "portscan"){
                            portscanOn = true
                            portscan = service.uuid.uuidString.lowercased()
                        }
                    }
                    if(spotDevices){
                        if(!portscanOn){
                            rows.append(Row(id: UUID(), contentBeforeUUID: "\(spotedDeviceName!)", uuid: "\(spotedDevice!)", contentAfterUUID: ""))
                            rows.append(Row(id: UUID(), contentBeforeUUID: "\t portscan failed", uuid: "", contentAfterUUID: ""))
                            self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: "spot", output:rows))
                        }else{
                            self.use(targetDevice: spotedDevice!, serviceUUID: portscan)
                        }
                        self.spotDevices = false
                    }
                  
                }

                }else {
                var rows:[Row] = []
                    rows.append(Row(id: UUID(), contentBeforeUUID: "'\(spotedDeviceName!)'", uuid: "", contentAfterUUID: ""))
                    rows.append(Row(id: UUID(), contentBeforeUUID: "• UUID:", uuid: "\(spotedDevice!)", contentAfterUUID: ""))
                    rows.append(Row(id: UUID(), contentBeforeUUID: "• Services:", uuid: "", contentAfterUUID: ""))
                for service in data.services!{
                    if service.name == "ssh"{
                        rows.append(Row(id: UUID(), contentBeforeUUID: "\t◦ ssh", uuid: "\(service.uuid.uuidString.lowercased())", contentAfterUUID: ""))
                    }else if service.name == "telnet"{
                        rows.append(Row(id: UUID(), contentBeforeUUID: "\t◦ telnet", uuid: "\(service.uuid.uuidString.lowercased())", contentAfterUUID: ""))
                    }
                }
                self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: "spot", output:rows))
            }


        }else if(data.error != nil){
            if(data.error! == "already_own_this_service"){
                self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "Service has already been created", uuid: "", contentAfterUUID: "")]))
                self.viewModel!.input = ""
            }else if(data.error! == "attack_already_running"){
                self.viewModel!.serviceRunning = true
                self.viewModel!.stop()
                self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "A bruteforce attack is already running", uuid: "", contentAfterUUID: "")]))
                self.viewModel!.input = ""
            }

        }else if(data.files != nil){
            if(listFiles){
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
                self.listFiles = false
            }else{
                self.files.removeAll()
                for file in data.files!{
                    self.files.append(file)
                }
            }
            
        }else if(data.ok != nil){
            if(doBruteforce){
                if(!viewModel!.serviceRunning){
                    if(data.ok!){
                        self.viewModel!.serviceRunning = true
                        self.viewModel!.input = ""
                    }else{
                        self.viewModel!.serviceRunning = true
                        self.viewModel!.stop()
                        self.viewModel!.input = ""
                    }
                }
             
            }else if(connectToDevice){
                if(data.ok!){
                    self.connected = true
                }else if(self.connectedDevices.count == 1){
                    self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "Welcome back at home!", uuid: "", contentAfterUUID: "")]))
                    self.viewModel!.input = ""
                }else{
                    self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "Access denied! You have no access to this device", uuid: "", contentAfterUUID: "")]))
                    self.viewModel!.input = ""
                }
            }
        }else{
            self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "An error occured", uuid: "", contentAfterUUID: "")]))
            self.viewModel!.input = ""
        }
        if(data.access != nil){
            if(doBruteforce){
                self.viewModel!.serviceRunning = false
                if(data.access!){
                    self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "Access granted use 'connect' to connect with device", uuid: "", contentAfterUUID: "")]))
                    
                }else{
                    self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "Access denied. Bruteforce attack was not successfull", uuid: "", contentAfterUUID: "")]))
                   
                }
                self.viewModel?.input = ""
                
            }
        }
    }
            
       
    func spot()  {
        do {
            let uuid = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "spot"], data:MSData(device_uuid:nil, name: nil, service_uuid: nil, target_device: nil, parent_dir_uuid: "", filename: nil, is_directory:nil,content:nil, target_service: nil, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil)))
            print(String(data: req, encoding: .utf8)!)
            self.spotDevices = true
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
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["list"], data:MSData(device_uuid: deviceUUID, name: nil, service_uuid: nil, target_device: nil, parent_dir_uuid: "", filename: nil, is_directory:nil,content:nil,target_service: nil, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil)))
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
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["use"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice")!,name: nil, service_uuid: serviceUUID, target_device: targetDevice, parent_dir_uuid: "", filename: nil, is_directory:nil,content:nil, target_service: nil, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil)))
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
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "change_name"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: new, service_uuid: nil, target_device: nil,parent_dir_uuid: "", filename: nil, is_directory:nil,content:nil, target_service: nil, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil)))
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
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["create"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: name,service_uuid: nil, target_device: nil, parent_dir_uuid: "",filename: nil, is_directory:nil,content:nil, target_service: nil, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil)))
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
    func list(parent_dir:String?, doPrint:Bool){
        do {
            let uuid = UUID()
            self.listFiles = doPrint
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["file", "all"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: nil,service_uuid: nil, target_device: nil,parent_dir_uuid: parent_dir, filename: nil, is_directory:nil,content:nil , target_service: nil, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil)))
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
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["file", "create"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: nil,service_uuid: nil, target_device: nil,parent_dir_uuid: parent_dir, filename: name, is_directory:false, content:content , target_service: nil, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil)))
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
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["file", "create"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: nil,service_uuid: nil, target_device: nil,parent_dir_uuid: parent_dir, filename: name, is_directory:true, content:"" , target_service: nil, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil)))
            print(String(data: req, encoding: .utf8)!)
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            socket.msHandlers.append(handler)
            handler.send()
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
    }
    func cd(name:String) {
        if(name == ".."){
            if(self.viewModel!.path == "/"){
                self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "You are already in the root directory", uuid: "", contentAfterUUID: "")]))
                self.viewModel!.input = ""
                return
            }else{
                var path:[String] = self.viewModel!.path.components(separatedBy: "/")
                _ = path.popLast()
                _ = self.viewModel!.pathMemory.popLast()
                self.viewModel!.path = ""
                for i in 0..<path.count{
                    if(i == 0){
                        self.viewModel!.path += String(path[i])
                    }else{
                        self.viewModel!.path += "/" + String(path[i])
                    }
                    
                }
                if(self.viewModel!.path == ""){
                    self.viewModel!.path = "/"
                    self.viewModel!.parent_dir = nil
                }else{
                    self.viewModel!.parent_dir = self.viewModel!.pathMemory[self.viewModel!.pathMemory.count - 1]
                }
                self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "", uuid: "", contentAfterUUID: "")]))
                self.viewModel!.input = ""
            }
           
           
        }else{
            for file in self.files{
                if(file.filename == name){
                    if(!file.is_directory){
                        self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "That is not a directory", uuid: "", contentAfterUUID: "")]))
                        self.viewModel!.input = ""
                        return
                    }else{
                        self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "", uuid: "", contentAfterUUID: "")]))
                        self.viewModel?.parent_dir = file.uuid.uuidString.lowercased()
                        if(self.viewModel!.path == "/"){
                            self.viewModel!.path += file.filename
                            self.viewModel!.parent_dir_name = file.filename
                            self.viewModel!.pathMemory.append(file.uuid.uuidString.lowercased())
                        }else{
                            self.viewModel!.path += "/" + file.filename
                            self.viewModel!.parent_dir_name = file.filename
                            self.viewModel!.pathMemory.append(file.uuid.uuidString.lowercased())
                        }
                       
                        self.viewModel!.input = ""
                        return
                    }
                    
                }
            }
            self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "That directory does not exist", uuid: "", contentAfterUUID: "")]))
            self.viewModel!.input = ""
        }
        self.list(parent_dir: self.viewModel!.parent_dir, doPrint: false)
    }
    
    func bruteforce(device:String, service:String){
        if(bruteforceService == ""){
            self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "The bruteforce service has not been created yet", uuid: "", contentAfterUUID: "")]))
            self.viewModel!.input = ""
        }else{
            do {
                let uuid = UUID()
                let req = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["bruteforce", "attack"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: nil,service_uuid: bruteforceService, target_device: device,parent_dir_uuid: "", filename: nil, is_directory:nil, content:nil, target_service: service, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil)))
                self.doBruteforce = true
                print(String(data: req, encoding: .utf8)!)
                let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
                socket.msHandlers.append(handler)
                handler.send()
                
            }catch let error {
                print("Error serializing JSON:\n\(error)")
                
            }
        }
     
    }
    func stop(){
        if(self.viewModel!.serviceRunning){
            do {
                let uuid = UUID()
                let req = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["bruteforce", "stop"], data:MSData(device_uuid: defaults.string(forKey: "currentDevice"), name: nil,service_uuid: bruteforceService, target_device: nil,parent_dir_uuid: "", filename: nil, is_directory:nil, content:nil, target_service: nil, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil )))
                self.doBruteforce = true
                print(String(data: req, encoding: .utf8)!)
                let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
                socket.msHandlers.append(handler)
                handler.send()
                
            }catch let error {
                print("Error serializing JSON:\n\(error)")
                
            }
        }else{
            self.viewModel!.output.append(TerminalOutput(id: UUID(), username: self.viewModel!.user, deviceName: self.viewModel!.device, path: self.viewModel!.path, command: viewModel!.input, output:[Row(id: UUID(), contentBeforeUUID: "Nothing to stop", uuid: "", contentAfterUUID: "")]))
            self.viewModel!.input = ""
        }
    }
    func connect(device:String){
        do {
            let uuid = UUID()
            let uuid2 = UUID()
            let req = try encoder.encode(MSRequest(tag: uuid, ms: "device", endpoint: ["device", "info"], data:MSData(device_uuid: device, name: nil,service_uuid: nil, target_device: nil,parent_dir_uuid: "", filename: nil, is_directory:nil, content:nil, target_service: nil, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil)))
            let req2 = try encoder.encode(MSRequest(tag: uuid, ms: "service", endpoint: ["part_owner"], data:MSData(device_uuid: device, name: nil,service_uuid: nil, target_device: nil,parent_dir_uuid: "", filename: nil, is_directory:nil, content:nil, target_service: nil, file_uuid: nil, new_parent_dir_uuid: "", new_filename: nil)))
            print(String(data: req, encoding: .utf8)!)
            print(String(data: req2, encoding: .utf8)!)
            connectToDevice = true
            let handler = MSHandler(socket: self.socket, tag: uuid, request: req, model: self)
            let handler2 = MSHandler(socket: self.socket, tag: uuid2, request: req2, model: self)
            socket.msHandlers.append(handler)
            socket.msHandlers.append(handler2)
            handler2.send()
            do{
                sleep(1)
            }
            handler.send()
            
            
        }catch let error {
            print("Error serializing JSON:\n\(error)")
            
        }
        print("To do")
        
    }
}
