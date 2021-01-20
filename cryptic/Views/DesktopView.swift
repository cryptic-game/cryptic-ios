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
            DeviceRunningProcessesView().tabItem { Image(systemName: "externaldrive.connected.to.line.below") }
            DeviceRunningProcessesView().tabItem { Image(systemName: "folder") }
            MinerView().tabItem { Image(systemName: "bitcoinsign.circle") }
           

        }
    }
}

struct DesktopView2_Previews: PreviewProvider {
    static var previews: some View {
        DesktopView(socket:Socket())
    }
}
