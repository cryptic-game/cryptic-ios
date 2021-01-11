//
//  crypticApp.swift
//  cryptic
//
//  Created by Nils Grob on 06.01.21.
//

import SwiftUI

@main
struct crypticApp: App {
    //var socket:Socket = .init() 
    var body: some Scene {
        //let = ContentViewModel(socket: socket)
        WindowGroup {
           //ContentView().environmentObject(settings)
            DesktopView()
            //DashboardView()
            //LoginView(socket: socket)
        }
    }
}
