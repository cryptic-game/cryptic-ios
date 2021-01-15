//
//  TerminalViewModel.swift
//  cryptic
//
//  Created by Nils Grob on 11.01.21.
//

import Foundation

final class TerminalViewModel:ViewModel, ObservableObject{
    @Published var output:[TerminalOutput] = []
    @Published var path:String = "/"
    @Published var user:String = UserDefaults.standard.string(forKey: "username")!
    @Published var device:String = UserDefaults.standard.string(forKey: "currentDeviceName")!
    @Published var lastLogin:Double = UserDefaults.standard.double(forKey: "lastLogin")
    @Published var input:String = ""
    var parent_dir:String? = nil
    
    
    @objc func getStatus()
    {
        super.model.getStatus()
    }
    func changeHost(new:String){
        (model as! Terminal).changeHost(new:new)
        self.device = new
    }
    func spot() {
        (model as! Terminal).spot()
    }
    func create(name:String){
        (model as! Terminal).create(name: name)
    }
    func listServices() {
        (model as! Terminal).listServices = true
        (model as! Terminal).listAllServices(deviceUUID: UserDefaults.standard.string(forKey: "currentDevice")!)

    }
    func list(){
        if(self.path == "/"){
            (model as! Terminal).list(parent_dir: nil)
        }else{
            (model as! Terminal).list(parent_dir: parent_dir)
        }
    }
    
    func touch(name:String, content:String){
        (model as! Terminal).touch(name: name, content: content, parent_dir: self.parent_dir)
    }
    func cat(name:String){
        (model as! Terminal).cat(name: name)
    }
    func mkdir(name:String){
        (model as! Terminal).mkdir(name: name, parent_dir: self.parent_dir)
    }
    init(socket:Socket) {
        super.init(model: Terminal(socket: socket))
        super.model.socket.viewModel = self
        (model as! Terminal).viewModel = self
        getStatus()
        _ = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.getStatus), userInfo: nil, repeats: true)
        
    }
}
