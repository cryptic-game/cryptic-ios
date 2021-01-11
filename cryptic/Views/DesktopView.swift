//
//  DesktopView.swift
//  cryptic
//
//  Created by Nils Grob on 10.01.21.
//

import SwiftUI

struct DesktopView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(){
                HStack(spacing: 15){
                    ZStack{
                        Rectangle().frame(width: 100   , height: 100).cornerRadius(25).shadow(color: .gray, radius: 3).foregroundColor(Color("ForegroundColor"))
                        Image("Miner").resizable().frame(width: 80, height: 80)
                        }
                    ZStack{
                        Rectangle().frame(width: 100, height: 100).cornerRadius(25).shadow(color: .gray, radius: 3).foregroundColor(Color( "ForegroundColor"))
                        Image("Terminal").resizable().frame(width: 80, height: 80)
                    }
                    ZStack{
                        Rectangle().frame(width: 100, height: 100).cornerRadius(25).shadow(color: .gray, radius: 3).foregroundColor(Color( "ForegroundColor"))
                        Image("Wallet").resizable().frame(width: 80, height: 80)
                    }

                }
            }
        }
    }
}

struct DesktopView_Previews: PreviewProvider {
    static var previews: some View {
        DesktopView()
    }
}
