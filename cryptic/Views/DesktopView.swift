//
//  DesktopView2.swift
//  cryptic
//
//  Created by Nils Grob on 11.01.21.
//

import SwiftUI

struct DesktopView: View {
    var body: some View {
        TabView{
            TerminalView(output: [TerminalOutput(id: UUID(), username: "homo-iocus", deviceName: "Kore", path: "/", command: "ls", output: "..\n.")]).tabItem { Image(systemName: "terminal") }
            TerminalView(output: [TerminalOutput(id: UUID(), username: "homo-iocus", deviceName: "Kore", path: "/", command: "ls", output: "..\n.")]).tabItem { Image(systemName: "externaldrive.connected.to.line.below") }
            TerminalView(output: [TerminalOutput(id: UUID(), username: "homo-iocus", deviceName: "Kore", path: "/", command: "ls", output: "..\n.")]).tabItem { Image(systemName: "folder") }
            TerminalView(output: [TerminalOutput(id: UUID(), username: "homo-iocus", deviceName: "Kore", path: "/", command: "ls", output: "..\n.")]).tabItem { Image(systemName: "bitcoinsign.circle") }
            TerminalView(output: [TerminalOutput(id: UUID(), username: "homo-iocus", deviceName: "Kore", path: "/", command: "ls", output: "..\n.")]).tabItem { Image(systemName: "folder") }
            TerminalView(output: [TerminalOutput(id: UUID(), username: "homo-iocus", deviceName: "Kore", path: "/", command: "ls", output: "..\n.")]).tabItem { Image(systemName: "folder") }

        }
    }
}

struct DesktopView2_Previews: PreviewProvider {
    static var previews: some View {
        DesktopView()
    }
}
