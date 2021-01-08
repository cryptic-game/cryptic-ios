//
//  RespondsHandler.swift
//  cryptic
//
//  Created by Nils Grob on 08.01.21.
//

import Foundation

struct ResponseHandler {
    
    var viewModel:ViewModel
    
    init(viewModel:ViewModel) {
        self.viewModel = viewModel
    }
    func responseHandler(response:Response){
        if(response.error != nil){
            let err = response.error!
            if(err == "permissions denied"){
                viewModel.showAlert(error: "Wrong Credentials")
                print("To do send error to view model")
            }
        }
        print("To do handle this data: \(response)")
    }
        
}


