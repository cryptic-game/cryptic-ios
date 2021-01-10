//
//  MSHandler.swift
//  cryptic
//
//  Created by Nils Grob on 09.01.21.
//

import Foundation

class MSHandler: ObservableObject{
    let socket:Socket
    let tag:UUID
    let request:Data
    let model:Model
    var response:ResponseData?{
        didSet{
            model.receive(data: response!)
        }
    }
    
    init(socket:Socket, tag:UUID, request:Data, model:Model) {
        self.socket = socket
        self.tag = tag
        self.request = request
        self.response = nil
        self.model = model
    }
    
    func send(){
        socket.connection.write(string: String(data: request, encoding: .utf8)!)
    }
    
    func receive(response:ResponseData){
        self.response = response
    }
}
