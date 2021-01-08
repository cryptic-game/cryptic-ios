//
//  crypticApp.swift
//  cryptic
//
//  Created by Nils Grob on 06.01.21.
//

import SwiftUI

@main
struct crypticApp: App {
    var socket:Socket = .init()
    var body: some Scene {
        WindowGroup {
            LoginView(socket: socket)
        }
    }
}
