//
//  DeviceSpecificationView.swift
//  cryptic
//
//  Created by Nils Grob on 07.01.21.
//

import SwiftUI

struct DeviceSpecificationView: View {
    var body: some View {
            VStack{
                HStack{
                    Spacer().frame(width: 20)
                    Text("Device specification").foregroundColor(Color("ForegroundColor")).bold().font(.title)
                    Spacer()
                }
                Spacer().frame(height: 20)
                HStack{
                    Spacer().frame(width: 20)
                    VStack(alignment: .leading){
                        Text("Device name").foregroundColor(.white)
                        Text("Processor").foregroundColor(.white)
                        Text("Installed RAM").foregroundColor(.white)
                        Text("Device-UUID").foregroundColor(.white)
                        
                    }
                    Spacer().frame(width: 20)
                    VStack(alignment: .leading){
                        Spacer().frame(height: 15)
                        Text("Kore").foregroundColor(.white)
                        Text("Core One A100").foregroundColor(.white)
                        Text("128 MB").foregroundColor(.white)
                        Text("d3cdea32-f2f5-4e26-8314-9da40a90938a").font(.system(size: 15)).foregroundColor(.white)
                    }
                    Spacer()
                }
                Spacer()
            }.background(Color("BackgroundColor"))
          
        }
     
    }


struct DeviceSpecificationView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSpecificationView()
    }
}
