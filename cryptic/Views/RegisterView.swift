//
//  RegisterView.swift
//  cryptic
//
//  Created by Nils Grob on 07.01.21.
//

import SwiftUI

struct RegisterView: View {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    @EnvironmentObject var content:ContentViewModel
    @State var email:String = ""
    var body: some View {
        NavigationView{
            ZStack{
                Color("BackgroundColor").ignoresSafeArea()
                VStack{
                    Image("Gradient").resizable().frame(height: screenHeight * 0.7  ).ignoresSafeArea()
                    Spacer()
                }
               
                VStack{
                    Spacer().frame(height: 0)
                    Image("Logo").resizable().frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Spacer().frame(height: 50)
                    Text("Register").font(.largeTitle).foregroundColor(.white).bold()
                    ZStack{
                        Rectangle().foregroundColor(Color("SecondaryColor")).frame(width: screenWidth * 0.9, height: screenHeight * 0.45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(25).shadow(color: .gray, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        VStack{
                            Spacer()
                            Text("Hi welcome!\n Register to start playing cryptic. ").multilineTextAlignment(.center).foregroundColor(.white)
                            Spacer().frame(height: 10)
                            VStack{
                                TextField("  Username", text: $email).background(Color("ForegroundColor")).frame(width: screenWidth*0.8).cornerRadius(5)
                                Spacer().frame(height: 15)
                                SecureField("  Pasword", text: $email).background(Color("ForegroundColor")).frame(width: screenWidth*0.8).cornerRadius(5)
                                Spacer().frame(height: 15)
                                SecureField("  Repeat pasword", text: $email).background(Color("ForegroundColor")).frame(width: screenWidth*0.8).cornerRadius(5)
                                Spacer().frame(height:10)
                                Text("The username must have between 2 and 32 characters.\n Your password has to be at least 8 characters long,\n it must contain at least one uppercase letter,\n one lowercase letter and one number.").multilineTextAlignment(.center).foregroundColor(.white).font(.system(size: 8))
                                //Spacer().frame(height:30)
                                
                                
                            }
                            
                            Button(action: {
                                //ToDo: Register and check input
                            }, label: {
                                ZStack{
                                    Image("Gradient").resizable().frame(width: UIScreen.main.bounds.width * 0.8, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    Text("Register").foregroundColor(.white).bold()
                                }
                            })
                            Spacer()
                        }
                    }
                }
            }.navigationBarItems(
                leading: Button(action: {
                    content.showLogin = true
                    content.showRegister = false
                }, label: { HStack{
                    Image(systemName: "chevron.backward")
                    Text("Back") }})
            )
        }
        
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
