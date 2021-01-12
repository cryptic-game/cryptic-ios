//
//  TerminalViewModel.swift
//  cryptic
//
//  Created by Nils Grob on 11.01.21.
//

import Foundation

final class TerminalViewModel:ViewModel, ObservableObject{
    @Published var output:[TerminalOutput] = []
    @Published var online:Int
    @Published var path:String = "/"
    @Published var user:String = "homo-iocus"
    @Published var device:String = "Kore"
   
    
    
    @objc func getStatus()
    {
        super.model.getStatus()
    }
    
    init(socket:Socket) {
        self.online = 0
        super.init(model: Model(socket: socket))
        super.model.socket.viewModel = self
        getStatus()
        _ = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.getStatus), userInfo: nil, repeats: true)
        
    }
}
