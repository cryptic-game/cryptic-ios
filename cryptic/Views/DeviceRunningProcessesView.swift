//
//  DeviceRunningProcessesView.swift
//  cryptic
//
//  Created by Nils Grob on 07.01.21.
//

import SwiftUI

struct DeviceRunningProcessesView: View {
    var body: some View {
        VStack{
            HStack{
                Spacer().frame(width: 20)
                Text("Running Processes").foregroundColor(Color("ForegroundColor")).bold().font(.title)
                Spacer()
            }
            Spacer().frame(height: 20)
            HStack{
                Spacer().frame(width: 20)
                VStack(alignment: .leading){
                    Text("Speed").foregroundColor(.white)
                    Text("Security").foregroundColor(.white)
                    Text("Efficiency").foregroundColor(.white)
                   
                    
                }
                Spacer().frame(width: 30)
                VStack(alignment: .leading){
                    //Spacer().frame(height: 15)
                    Text("not available").foregroundColor(.white)
                    Text("not available").foregroundColor(.white)
                    Text("not available").foregroundColor(.white)
                   
                }
                Spacer()
            }
            Spacer()
        }.background(Color("BackgroundColor"))
    }
}

struct DeviceRunningProcessesView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceRunningProcessesView()
    }
}
