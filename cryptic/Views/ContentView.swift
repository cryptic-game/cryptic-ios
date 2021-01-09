//
//  ContentView.swift
//  cryptic
//
//  Created by Nils Grob on 06.01.21.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var content:ContentViewModel
    //var socket:Socket = .init()
    func retournValues(){
        print("From Content View:\(content.isLoggedIn)")
    }
    
    var body: some View {
        if(content.showLogin){
            LoginView(socket: content.model.socket)
        }else if(content.showRegister){
            RegisterView()
        }else if(content.isLoggedIn){
            DashboardView(socket:content.model.socket)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
