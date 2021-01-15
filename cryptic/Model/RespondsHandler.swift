//
//  RespondsHandler.swift
//  cryptic
//
//  Created by Nils Grob on 08.01.21.
//

import Foundation

class ResponseHandler {
    var defaults = UserDefaults.standard
    var viewModel:ViewModel
    var content:ContentViewModel
    var MSHandlers:[MSHandler]
    
    init(viewModel:ViewModel, content: ContentViewModel, msHandlers:[MSHandler]) {
        self.viewModel = viewModel
        self.content = content
        self.MSHandlers = msHandlers
    }
    func responseHandler(response:Response){
        if(response.error != nil){
            let err = response.error!
            if(err == "permissions denied"){
                viewModel.showAlert(error: "Wrong Credentials")
                //print("To do send error to view model")
            }else if(err == "invalid token"){
                defaults.set(false, forKey: "loggedIn")
                DispatchQueue.main.async {
                    self.content.isLoggedIn = false
                    self.content.showLogin = true
                    self.content.showRegister = false
                    }
            }
        }
        if(response.token != nil){
            defaults.set(response.token!, forKey: "token")
            defaults.set(true, forKey:"loggedIn")
            DispatchQueue.main.async {
                self.content.isLoggedIn = true
                self.content.showLogin = false
                self.content.showRegister = false
                }
            //content.isLoggedIn = true
            
        }
        if(response.status != nil){
            if(response.status! == "logout"){
                defaults.set(false, forKey:"loggedIn")
                DispatchQueue.main.async {
                    self.content.isLoggedIn = false
                    self.content.showLogin = true
                    self.content.showRegister = false
                    }
            }
        }
        if(response.tag != nil){
            var numberOfHandlers = MSHandlers.count
            for i in 0..<numberOfHandlers{
                if(MSHandlers[i].tag == UUID(uuidString: response.tag!)){
                    numberOfHandlers -= 1
                    MSHandlers[i].receive(response: response.data!)
                    MSHandlers.remove(at: i)
                }
            }
           
        }
        if(response.name != nil){
            defaults.set(response.name!, forKey: "username")
            defaults.set(response.uuid!.uuidString.lowercased(), forKey: "userUUID")
        }
        
        if(response.online != nil){
            print("hello")
            defaults.set(response.last!, forKey: "lastLogin")
            //let vm = self.viewModel as! TerminalViewModel
            DispatchQueue.main.async {
                print("hello inside")
                self.viewModel.online = response.online!
                //vm.online = response.online!
            }
            //print("\(vm.online)")
        }
        print("To do handle this data: \(response)")
    }
        
}


