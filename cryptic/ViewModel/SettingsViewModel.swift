//
//  SettingsViewModel.swift
//  cryptic
//
//  Created by Nils Grob on 08.01.21.
//

import Foundation

final class SettingsViewModel:ViewModel, ObservableObject{
    @Published var oldPassword:String = ""
    @Published var newPassword: String = ""
    @Published var newPasswordRepeat:String = ""
    @Published var user:String = UserDefaults.standard.string(forKey: "username")!
    @Published var userUUID:String = UserDefaults.standard.string(forKey:"userUUID")!
    init(socket:Socket) {
        super.init(model: Model(socket: socket))
       // super.model.socket.viewModel = contenViewModel
    }
    
    func logout(){
        super.model.logout()
    }

}
