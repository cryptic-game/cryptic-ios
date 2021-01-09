//
//  ContentViewModel.swift
//  cryptic
//
//  Created by Nils Grob on 08.01.21.
//

import Foundation

final class ContentViewModel: ViewModel, ObservableObject{
    @Published var showLogin:Bool = !UserDefaults.standard.bool(forKey: "loggedIn")
    @Published var isLoggedIn:Bool = UserDefaults.standard.bool(forKey: "loggedIn")
//    @Published var showLogin:Bool = true
//    @Published var isLoggedIn:Bool = false
    @Published var showRegister:Bool = false
    
    init(socket:Socket) {
        super.init(model: Model(socket: socket))
        super.model.socket.viewModel = self
        super.model.socket.content = self
    }

}
