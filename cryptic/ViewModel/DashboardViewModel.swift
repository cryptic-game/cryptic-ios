//
//  DashboardViewModel.swift
//  cryptic
//
//  Created by Nils Grob on 09.01.21.
//

import Foundation

final class DashboardViewModel:ViewModel, ObservableObject {
    @Published var device:DeviceModel?
    @Published var isLoading:Bool
    
    init(socket:Socket) {
        self.device = nil
        self.isLoading = true
        super.init(model: Device(socket: socket))
        super.model.socket.viewModel = self
        self.getStatus()
        let mod = super.model as! Device
        mod.viewModel = self
        _ = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.getStatus), userInfo: nil, repeats: true)
    }
    
    func getAll() {
        let mod = model as! Device
        mod.getAll()
    }
    @objc func getStatus()
    {
        super.model.getStatus()
    }
    
}
