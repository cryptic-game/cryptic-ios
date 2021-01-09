//
//  LoginViewModel.swift
//  cryptic
//
//  Created by Nils Grob on 07.01.21.
//

import Foundation
import SwiftUI

struct AlertWrapper: Identifiable {
  let id = UUID()
  let alert: Alert
}

final class LoginViewModel:ViewModel, ObservableObject{
    var name:String = ""
    var password:String = ""
    

    init(socket:Socket) {
        super.init(model: Model(socket: socket))
        super.model.socket.viewModel = self
    }
    
    
    func login(completion:@escaping(Bool) ->()){
        if(name == "" || password == ""){
            return completion(false)
        }else{
            super.model.login(credentials: loginCredentials(action: "login", name: name, password: password))
        }
        
    }
}
