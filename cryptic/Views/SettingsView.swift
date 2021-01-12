//
//  SettingsView.swift
//  cryptic
//
//  Created by Nils Grob on 08.01.21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var content:ContentViewModel
    @ObservedObject var settings:SettingsViewModel
    
    init(socket:Socket) {
        settings = SettingsViewModel(socket: socket)
    }
    var body: some View {
        VStack{
            Spacer().frame(height:20)
            HStack{
                Spacer().frame(width: 20)
                Text("Account Settings").foregroundColor(Color("ForegroundColor")).bold().font(.title)
                Spacer()
            }
            
            Spacer().frame(height: 20)
            HStack(alignment: .top){
                Spacer().frame(width: 20)
                Text("Name:").foregroundColor(.white)
                Spacer().frame(width: 20)
                Text("\(settings.user)").foregroundColor(.white)
                Spacer()
            }
            Spacer().frame(height: 20)
            HStack(alignment: .top){
                Spacer().frame(width: 20)
                Text("UUID:").foregroundColor(.white)
                Spacer().frame(width: 20)
                Text("\(settings.userUUID)").foregroundColor(.white)
                Spacer()
                   
            }
            Spacer().frame(height: 20)
            HStack{
                Spacer().frame(width: 20)
                Text("Change Password").foregroundColor(Color("ForegroundColor")).bold().font(.title)
                Spacer()
            }
            Spacer()
            Button(action: {
                    settings.logout()
                    DispatchQueue.main.async {
                        self.content.isLoggedIn = false
                        self.content.showLogin = true
                    }
                    }, label: {
                        Text("Log Out").foregroundColor(.gray).bold()
                    })
        
                    

            
        }.background(Color("BackgroundColor"))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(socket: Socket())
    }
}
