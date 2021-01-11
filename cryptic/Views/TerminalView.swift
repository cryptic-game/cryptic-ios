//
//  TerminalView.swift
//  cryptic
//
//  Created by Nils Grob on 11.01.21.
//

import SwiftUI

struct TerminalView: View {
    @State var input = ""
    var body: some View {
        ZStack{
            Image("Logo")
            Color(.black).ignoresSafeArea().opacity(0.8)
            VStack{
                Spacer()
                HStack(spacing: 0){
                    Spacer()
                    Text("homo-iocus@Kore").foregroundColor(.green).font(.footnote)
                    Text(":").foregroundColor(.white).font(.footnote)
                    Text("/").foregroundColor(.blue).font(.footnote)
                    TextField("", text: $input).foregroundColor(.white).autocapitalization(.none)
                }
                Spacer().frame(height: 20)
            }
        }
    }
}

struct TerminalView_Previews: PreviewProvider {
    static var previews: some View {
        TerminalView()
    }
}
