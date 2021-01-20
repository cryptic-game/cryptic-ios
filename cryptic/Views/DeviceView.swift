//
//  DeviceView.swift
//  cryptic
//
//  Created by Nils Grob on 09.01.21.
//

import SwiftUI

struct DeviceView: View {
    @ObservedObject var viewModel:DashboardViewModel
    @EnvironmentObject var content:ContentViewModel
    @State var isLoading = false
    let socket:Socket
    
    init(socket:Socket) {
        self.socket = socket
        self.viewModel = DashboardViewModel(socket: socket)
    }
    var body: some View {
        VStack{
            if(viewModel.isLoading){
                VStack {
                    Text("Loading...").foregroundColor(.gray)
                    ProgressView().progressViewStyle(CircularProgressViewStyle()).foregroundColor(.white)
                }
            }else{
                HStack{
                    Spacer()
                    VStack{
                        Image("ComputerOnline").resizable().frame(width: 80, height: 80).onTapGesture {
                            DispatchQueue.main.async {
                                content.showDesktop = true
                            }
                        }
                        Spacer().frame(height: 0)
                        Text(viewModel.device?.name ?? "").foregroundColor(.white).bold().font(.title)
                        Spacer().frame(height: 20)
                        
                        
                    }
                    Spacer()
                    Image("OnButton").resizable().frame(width: 80, height: 80)
                    Spacer()
                }.frame(height: UIScreen.main.bounds.height * 0.2, alignment: .center)
                Spacer().frame(height:0)
                TabView{
                    DeviceSpecificationView(viewModel: self.viewModel)
                    DeviceSpecificFactorsView()
                    DeviceRunningProcessesView()
                }.tabViewStyle(PageTabViewStyle()).frame(height: 200)
                }
            }.background(Color("BackgroundColor")).onAppear{
            isLoading = true
            if(socket.didConnectProperly){
                viewModel.getAll()
            }else{
                print("socket isnt yet connectet")
            }
        }
       
    }
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceView(socket: Socket())
    }
}
