//
//  DesktopView2.swift
//  cryptic
//
//  Created by Nils Grob on 11.01.21.
//

import SwiftUI

struct DesktopView: View {
    let socket:Socket
    init(socket:Socket) {
        self.socket = socket
    }
    var body: some View {
        TabView{
            TerminalView(socket:socket).tabItem { Image(systemName: "terminal") }
            TerminalView(socket:socket).tabItem { Image(systemName: "externaldrive.connected.to.line.below") }
            TerminalView(socket:socket).tabItem { Image(systemName: "folder") }
            TerminalView(socket:socket).tabItem { Image(systemName: "bitcoinsign.circle") }
            TerminalView(socket:socket).tabItem { Image(systemName: "folder") }
            TerminalView(socket:socket).tabItem { Image(systemName: "folder") }

        }
    }
}

struct DesktopView2_Previews: PreviewProvider {
    static var previews: some View {
        DesktopView(socket:Socket())
    }
}
