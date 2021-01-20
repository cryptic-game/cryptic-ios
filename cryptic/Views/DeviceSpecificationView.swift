//
//  DeviceSpecificationView.swift
//  cryptic
//
//  Created by Nils Grob on 07.01.21.
//

import SwiftUI

struct DeviceSpecificationView: View {
    @ObservedObject var viewModel:DashboardViewModel
    
    init(viewModel:DashboardViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
            VStack{
                HStack{
                    Spacer().frame(width: 20)
                    Text("Device specification").foregroundColor(Color("ForegroundColor")).bold().font(.title)
                    Spacer()
                }
                Spacer().frame(height: 0)
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
                        Text(viewModel.device?.name ?? "").foregroundColor(.white)
                        Text(viewModel.device?.hardware?[2].hardware_element ?? "").foregroundColor(.white)
                        Text("128 MB").foregroundColor(.white)
                        Text(viewModel.device?.uuid.uuidString.lowercased() ?? "").font(.system(size: 15)).foregroundColor(.white)
                    }
                    Spacer()
                }
                Spacer()
            }.background(Color("BackgroundColor"))
          
        }
     
    }


struct DeviceSpecificationView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSpecificationView(viewModel: DashboardViewModel(socket: Socket()))
    }
}
