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
    
    
    
    @objc func getStatus()
    {
        super.model.getStatus()
    }
    func changeHost(new:String){
        (model as! Terminal).changeHost(new:new)
        self.device = new
    }
    init(socket:Socket) {
        super.init(model: Terminal(socket: socket))
        super.model.socket.viewModel = self
        getStatus()
        _ = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.getStatus), userInfo: nil, repeats: true)
        
    }
}
