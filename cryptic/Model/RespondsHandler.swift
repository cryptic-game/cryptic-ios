//
//  RespondsHandler.swift
//  cryptic
//
//  Created by Nils Grob on 08.01.21.
//

import Foundation

struct ResponseHandler {
    var defaults = UserDefaults.standard
    var viewModel:ViewModel
    var content:ContentViewModel
    
    init(viewModel:ViewModel, content: ContentViewModel) {
        self.viewModel = viewModel
        self.content = content
    }
    func responseHandler(response:Response){
        if(response.error != nil){
            let err = response.error!
            if(err == "permissions denied"){
                viewModel.showAlert(error: "Wrong Credentials")
                //print("To do send error to view model")
            }
        }else if(response.token != nil){
            defaults.set(response.token!, forKey: "token")
            defaults.set(true, forKey:"loggedIn")
            DispatchQueue.main.async {
                self.content.isLoggedIn = true
                self.content.showLogin = false
                self.content.showRegister = false
                }
            //content.isLoggedIn = true
            
        }
        print("To do handle this data: \(response)")
    }
        
}


