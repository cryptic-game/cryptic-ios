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
    @State var email:String = ""
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            VStack{
                Image("Gradient").resizable().frame(height: screenHeight * 0.7  ).ignoresSafeArea()
                Spacer()
            }
           
            VStack{
                Image("Logo").resizable().frame(width: screenWidth * 0.025 * 20.7, height: screenHeight * 0.01 * 28.2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Spacer().frame(height: 50)
                Text("Register").font(.largeTitle).foregroundColor(.white).bold()
                ZStack{
                    Rectangle().foregroundColor(Color("SecondaryColor")).frame(width: screenWidth * 0.9, height: screenHeight * 0.45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(25).shadow(color: .gray, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                    VStack{
                        Spacer()
                        Text("Hi welcome!\n Register to start playing cryptic. ").multilineTextAlignment(.center).foregroundColor(.white)
                        Spacer().frame(height: 30)
                        VStack{
                            TextField("  Email", text: $email).background(Color("ForegroundColor")).frame(width: screenWidth*0.8).cornerRadius(5)
                            Spacer().frame(height: 30)
                            SecureField("  Pasword", text: $email).background(Color("ForegroundColor")).frame(width: screenWidth*0.8).cornerRadius(5)
                            Spacer().frame(height: 30)
                            SecureField("  Repeat pasword", text: $email).background(Color("ForegroundColor")).frame(width: screenWidth*0.8).cornerRadius(5)
                            Spacer().frame(height:30)
                            Text("The username must have between 2 and 32 characters.\n Your password has to be at least 8 characters long,\n it must contain at least one uppercase letter,\n one lowercase letter and one number.").multilineTextAlignment(.center).foregroundColor(.white).font(.system(size: 13))
                            Spacer().frame(height:30)
                            
                            
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
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
