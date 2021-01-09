//
//  DashboardViewModel.swift
//  cryptic
//
//  Created by Nils Grob on 09.01.21.
//

import Foundation

class DashboardViewModel:ViewModel, ObservableObject {
    @Published var device:DeviceModel
    
    init(device:DeviceModel, socket:Socket) {
        self.device = device
        super.init(model: Device(socket: socket))
        super.model.socket.viewModel = self
        
    }
    
    func getAll() {
        let mod = model as! Device
        mod.getAll()
    }
}
