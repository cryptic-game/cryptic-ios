//
//  TerminalViewModel.swift
//  cryptic
//
//  Created by Nils Grob on 11.01.21.
//

import Foundation

final class TerminalViewModel:ViewModel, ObservableObject{
    @Published var output:[TerminalOutput] = []
    @Published var path:String = "/"
    
    
    init(socket:Socket) {
        super.init(model: Model(socket: socket))
        super.model.socket.viewModel = self
    }
}
