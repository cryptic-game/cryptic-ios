//
//  Socket.swift
//  cryptic
//
//  Created by Nils Grob on 08.01.21.
//

import Foundation
import Starscream



class Socket:WebSocketDelegate {
    var connection: WebSocket!
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var viewModel:ViewModel?
    var content:ContentViewModel?
    var defaults = UserDefaults.standard
    
    init() {
        
        //connection = WebSocket(url: URL(string: "wss://ws.test.cryptic-game.net")!)
        connection = WebSocket(url: URL(string: "ws://127.0.0.1/")!)
        viewModel = nil
        content = nil
        connection.delegate = self
        connection.connect()
    }
   
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        do {
            let jsonData = text.data(using: .utf8)!
            let data = try decoder.decode(Response.self, from: jsonData)
            ResponseHandler(viewModel: viewModel!, content: content!).responseHandler(response: data)
            
            
        } catch let error {
            print("\(error)")
        }
        
        
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data)")
    }
    func websocketDidConnect(socket: WebSocketClient) {
        do {
            let data = try encoder.encode(LoginToken(action: "session", token: defaults.string(forKey: "token") ?? " "))
            self.connection.write(string: String(data: data, encoding: .utf8)!)
        }catch let error {
            print(" Error serializing JSON:\n\(error)")
            
        }
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        viewModel?.showAlert(error: "Check your internet connection!")
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
    }
    
}


