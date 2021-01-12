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
                    ScrollViewReader{ value in
                        ForEach(viewModel.output){ output in
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
                        }.onChange(of: viewModel.output.count) { _ in
                            if(viewModel.output.count != 0){
                                value.scrollTo(viewModel.output[viewModel.output.count - 1].id)
                            }
                            
                        }
                    }
                    
                }
             
                Spacer()
                HStack(spacing: 0){
                    Spacer().frame(width: 20)
                    Text("\(viewModel.user)@\(viewModel.device)").foregroundColor(.green).font(.footnote)
                    Text(":").foregroundColor(.white).font(.footnote)
                    Text("/").foregroundColor(.blue).font(.footnote)
                    Text("$").foregroundColor(.green).font(.footnote)
                    TextField("", text: $input, onEditingChanged:{editingChanged in
                        if(editingChanged){
                            print("started writing")
                        }else{
                            let regexHost = try! NSRegularExpression(pattern: "hostname [a-zA-Z]{1,14}")
                            let range = NSRange(location: 0, length: input.utf16.count)
                            if(input == "help"){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "help", output: "help\t\t\tlist of all commands\nstatus\t\tdisplays the number of online players\nhostname\tchanges the name of the device\ncd\t\t\tchanges the working directory\nlst\t\t\tshows files of the current working directory\nl\t\t\tshows files of the current working directory\ndir\t\t\tshows files of the current working directory\ntouch\t\tcreate a file\ncat\t\t\treads out a file\nrm\t\t\tdeletes a file or a directory\ncp\t\t\tcopys a file\nmv\t\t\tmoves a file\nrename\t\trenames a file\nmkdir\t\tcreates a direcotry\nexit\t\t\tcloses the terminal or leaves another device\nquit\t\t\tcloses the terminal or leaves another device\nclear\t\tclears the terminal\nhistory\t\tshows the command history of the session\nmorphcoin\tshows wallet\npay\t\t\tsends money to another wallet\nservice\t\tcreates or uses services\nspot\t\t\tspots other devices\nconnect\t\tconnects to other device\nnetwork\t\ttype `network` for further information\ninfo\t\t\tshows info of the current device"))
                                input = ""
                            }else if (input == "clear") {
                                viewModel.output = []
                                input = ""
                            }else if (input == "service") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "service", output:"usage: service create | list | bruteforce | portscan"))
                                input = ""
                                
                            }else if (input == "status") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "status", output:"Online players: \(viewModel.online)"))
                                input = ""
                                
                            }else if (input.contains("hostname") && input.count < 24){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: input, output:"The hostname couldn't be changed"))
                                input = ""

                            }else if (regexHost.firstMatch(in: input, options: [], range: range) != nil) {
                                let lineItems = input.split(separator: " ", maxSplits: 1)
                                viewModel.changeHost(new: String(lineItems[1]))
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: input, output:""))
                                input = ""
                                
                            }else if(input == "hostname"){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: input, output: viewModel.device))
                                input = ""
                            }else if (input.contains("hostname")){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: input, output:"The hostname couldn't be changed"))
                                input = ""

                            }else{
                                
                                viewModel.output.append(TerminalOutput(id: UUID(), username: "homo-iocus", deviceName: "Kore", path: "/", command: "\(input)", output: "Command could not be found.\nType `help` for a list of commands."))
                                input = ""
                            }
                        }
                        
                    }).foregroundColor(.white).autocapitalization(.none)//.background(Color("ForegroundColor")).cornerRadius(10)
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
