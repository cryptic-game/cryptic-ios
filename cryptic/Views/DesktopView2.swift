//
//  DesktopView2.swift
//  cryptic
//
//  Created by Nils Grob on 11.01.21.
//

import SwiftUI

struct DesktopView2: View {
    var body: some View {
        TabView{
            TerminalView().tabItem { Image(systemName: "terminal") }
            TerminalView().tabItem { Image(systemName: "externaldrive.connected.to.line.below") }
            TerminalView().tabItem { Image(systemName: "folder") }
            TerminalView().tabItem { Image(systemName: "bitcoinsign.circle") }
            TerminalView().tabItem { Image(systemName: "folder") }
            TerminalView().tabItem { Image(systemName: "folder") }

        }
    }
}

struct DesktopView2_Previews: PreviewProvider {
    static var previews: some View {
        DesktopView2()
    }
}
