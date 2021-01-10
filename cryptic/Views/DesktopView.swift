//
//  DesktopView.swift
//  cryptic
//
//  Created by Nils Grob on 10.01.21.
//

import SwiftUI

struct DesktopView: View {
    var body: some View {
        ProgressView().progressViewStyle(CircularProgressViewStyle()).foregroundColor(.green).frame(width: 100, height: 100)
    }
}

struct DesktopView_Previews: PreviewProvider {
    static var previews: some View {
        DesktopView()
    }
}
