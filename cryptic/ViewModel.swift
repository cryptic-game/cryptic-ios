//
//  ViewModel.swift
//  cryptic
//
//  Created by Nils Grob on 08.01.21.
//

import Foundation
import SwiftUI

class ViewModel{
    var model:Model
    var alert: Alert? {
        didSet {
          guard let a = self.alert else { return }
          DispatchQueue.main.async {
            self.alertWrapper = .init(alert: a)
          }
        }
    }
    @Published var alertWrapper: AlertWrapper?
    @Published var online:Int
    init(model:Model) {
        self.model = model
        self.online = 0
    }
    
    func showAlert(error:String) -> () {
        let alert = Alert(
                title: Text("Unable to connect to server!"),
                    message: Text(error),
                    dismissButton: .default(Text("Retry")) {
                        self.alert = nil
                        self.model.socket.connection.connect()
                    })
        self.alert = alert
    }
}
