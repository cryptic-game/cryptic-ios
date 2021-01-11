//
//  TerminalView.swift
//  cryptic
//
//  Created by Nils Grob on 11.01.21.
//

import SwiftUI

struct TerminalView: View {
    @ObservedObject var viewModel:TerminalViewModel
    @State var input = ""
    @State var output:[TerminalOutput] = []
    let socket:Socket
    
    init(socket:Socket) {
        self.socket = socket
        self.viewModel = TerminalViewModel(socket: socket)
    }
    var body: some View {
        ZStack{
            Image("Logo")
            Color(.black).ignoresSafeArea().opacity(0.8)
        
            VStack{
                ScrollView{
                    ForEach(output){ output in
                        VStack{
                            HStack(spacing: 0){
                                Spacer().frame(width: 20)
                                Text("\(output.username)@\(output.deviceName)").foregroundColor(.green).font(.footnote)
                                Text(":").foregroundColor(.white).font(.footnote)
                                Text("\(output.path)").foregroundColor(.blue).font(.footnote)
                                Text("$").foregroundColor(.green).font(.footnote)
                                Text("\(output.command)").foregroundColor(.white).font(.footnote)
                                Spacer()
                            }
                            HStack(spacing: 0){
                                Spacer().frame(width: 20)
                                Text("\(output.output)").foregroundColor(.white).font(.footnote)
                                Spacer()
                            }
                           
                        }
                    }
                }
             
                Spacer()
                HStack(spacing: 0){
                    Spacer().frame(width: 20)
                    Text("homo-iocus@Kore").foregroundColor(.green).font(.footnote)
                    Text(":").foregroundColor(.white).font(.footnote)
                    Text("/").foregroundColor(.blue).font(.footnote)
                    Text("$").foregroundColor(.green).font(.footnote)
                    TextField("", text: $input, onEditingChanged:{editingChanged in
                        if(editingChanged){
                            print("started")

                        }else{
                            if(input == "help"){
                                output.append(TerminalOutput(id: UUID(), username: "homo-iocus", deviceName: "Kore", path: "/", command: "help", output: "help    list of all commands\nstatus    displays the number of online players\nhostname    changes the name of the device\ncd    changes the working directory\nls    shows files of the current working directory\nl    shows files of the current working directory\ndir    shows files of the current working directory\ntouch    create a file\ncat    reads out a file\nrm    deletes a file or a directory\ncp    copys a file\nmv    moves a file\nrename    renames a file\nmkdir    creates a direcotry\nexit    closes the terminal or leaves another device\nquit    closes the terminal or leaves another device\nclear    clears the terminal\nhistory    shows the command history of the current terminal session\nmorphcoin    shows wallet\npay    sends money to another wallet\nservice    creates or uses services\nspot    spots other devices\nconnect    connects to other device\nnetwork    type `network` for further information\ninfo    shows info of the current device"))
                                input = ""
                            }else if (input == "clear") {
                                output = []
                                input = ""
                            }else{
                                output.append(TerminalOutput(id: UUID(), username: "homo-iocus", deviceName: "Kore", path: "/", command: "\(input)", output: "Command could not be found.\nType `help` for a list of commands."))
                                input = ""
                            }
                            
                            print("finished")
                        }
                        
                    }).foregroundColor(.white).autocapitalization(.none)
                }
                Spacer().frame(height: 20)
            }
        }
    }
}

struct TerminalView_Previews: PreviewProvider {
    static var previews: some View {
        TerminalView(socket: Socket())
    }
}
