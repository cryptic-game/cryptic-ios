//
//  LoginView.swift
//  cryptic
//
//  Created by Nils Grob on 06.01.21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel:LoginViewModel
    @EnvironmentObject var content:ContentViewModel
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    
    init(socket:Socket) {
        viewModel = LoginViewModel(socket: socket)
    }
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack{
                Image("Gradient").resizable().frame(height: screenHeight * 0.7  ).ignoresSafeArea()
                Spacer()
            }
           
            VStack{
                Image("Logo").resizable().frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Spacer().frame(height: 50)
                Text("Log In").font(.largeTitle).foregroundColor(.white).bold()
                ZStack{
                    Rectangle().foregroundColor(Color("SecondaryColor")).frame(width: screenWidth * 0.9, height: screenHeight * 0.45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(25).shadow(color: .gray, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                    VStack{
                        Spacer()
                        Text("Hi welcome back!\n Log In to manage your infrastructure ").multilineTextAlignment(.center).foregroundColor(.white)
                        Spacer().frame(height: 30)
                        TextField("  Username", text: $viewModel.name).background(Color("ForegroundColor")).frame(width: screenWidth*0.8).cornerRadius(5)
                        Spacer().frame(height: 30)
                        SecureField("  Pasword", text: $viewModel.password).background(Color("ForegroundColor")).frame(width: screenWidth*0.8).cornerRadius(5)
                        Spacer().frame(height:30)
                        Button(action: {
                            viewModel.login { (succsess) in
                                print("function called")
                            }
                        }, label: {
                            ZStack{
                                Image("Gradient").resizable().frame(width: UIScreen.main.bounds.width * 0.8, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                Text("Log In").foregroundColor(.white).bold()
                            }
                        })
                        VStack{
                            Text("Don't have an account yet?").foregroundColor(.gray)
                            Text("Create Account").foregroundColor(.gray).bold().onTapGesture {
                                print("clicked")
                                
                                DispatchQueue.main.async {
                                    print("not changed values\(content.showLogin)")
                                    self.content.showLogin = false
                                    self.content.showRegister = true
                                    print("changed values\(content.showLogin)")
                                   
                                }
                            }
                        }
                       Spacer()
                        
                    }
                }
                Spacer().frame(height: 5)
            }.alert(item: $viewModel.alertWrapper) { $0.alert }
        }
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(socket: Socket())
    }
}
