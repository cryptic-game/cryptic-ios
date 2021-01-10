//
//  DashboardView.swift
//  cryptic
//
//  Created by Nils Grob on 06.01.21.
//

import SwiftUI

struct DashboardView: View {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    let socket:Socket
    let viewModel:DashboardViewModel
    
    @State var chosen:Int = -1
    init(socket:Socket) {
        self.socket = socket
        self.viewModel = DashboardViewModel(socket: socket)
    }
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack(){
                ZStack{
                    Image("Gradient").resizable().ignoresSafeArea().frame(width: screenWidth, height: screenHeight * 0.15)
                    Image("LogoVertical").resizable().frame(width: screenWidth * 0.7, height: screenHeight * 0.08, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                HStack{
                    Spacer().frame(width: 20)
                    Text("Controll-Center").foregroundColor(.white).bold().font(.title)
                    Spacer()
                }
               
                ScrollView(.horizontal){
                    Spacer().frame(height:20)
                    HStack(spacing:20){
                        Spacer()
                        ForEach(0..<4){ i in
                            ZStack{
                                Rectangle().frame(width: screenWidth * 0.3, height: screenHeight * 0.15).cornerRadius(25).shadow(color: .gray, radius: 3).foregroundColor(Color(chosen == i ?"ForegroundColor":"SecondaryColor")).onTapGesture {
                                    chosen = i;
                                }
                                if(i == 0){
                                    Image("Laptop").resizable().frame(width: 100, height:100).onTapGesture {
                                        chosen = i;
                                    }
                                }else if(i==1){
                                    Image("Server").resizable().frame(width: 100, height:100).onTapGesture {
                                        chosen = i;
                                    }
                                }else if(i==2){
                                    Image("ChangeLog").resizable().frame(width: 100, height:100).onTapGesture {
                                        chosen = i;
                                    }
                                }else if(i == 3){
                                    Image("Settings").resizable().frame(width: 100, height:100).onTapGesture {
                                        chosen = i;
                                    }
                                }
                            }
                        }
                    }
                    Spacer().frame(height:20)
                }
                VStack(alignment: .leading){
                    if(chosen == 0){
                        DeviceView(socket:socket)
                    }else if(chosen == 3){
                        SettingsView(socket: socket)
                    }
                }
                Spacer()
                }
                
            }
            
        }
        
    }


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(socket: Socket())
    }
}
