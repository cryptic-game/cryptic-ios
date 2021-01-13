//
//  TerminalView.swift
//  cryptic
//
//  Created by Nils Grob on 11.01.21.
//

import SwiftUI

struct TerminalView: View {
    @ObservedObject var viewModel:TerminalViewModel
    @State var output:[TerminalOutput] = []
    let socket:Socket
    
    init(socket:Socket) {
        self.socket = socket
        self.viewModel = TerminalViewModel(socket: socket)
        let formatter = DateFormatter()
        formatter.dateFormat = "eeeeee, dd.MM.yyyy"
        self.viewModel.output.append((TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "", output:"Last login: \(formatter.string(from:(Date(milliseconds: Int64(viewModel.lastLogin)))))"))
)
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
                                    Text("\(output.output)").foregroundColor(.white).font(.footnote).onTapGesture {
                                        if(output.output.contains("UUID")){
                                            print("TO do copy UUID in input field")
                                        }
                                    }
                                    Spacer()
                                }
                               
                            }
                        }.onChange(of: viewModel.output.count) { _ in
                            if(viewModel.output.count != 0){
                                value.scrollTo(viewModel.output[viewModel.output.count - 1].id)
                            }
                            
                        }.onChange(of: viewModel.output[viewModel.output.count != 0 ? viewModel.output.count - 1: 0].output.count) { _ in
                            value.scrollTo(viewModel.output[viewModel.output.count - 1].id)
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
                    TextField("", text: $viewModel.input, onEditingChanged:{editingChanged in
                        if(editingChanged){
                            print("started writing")
                        }else{
                            let regexHost = try! NSRegularExpression(pattern: "hostname [a-zA-Z]{1,14}")
                            let range = NSRange(location: 0, length: viewModel.input.utf16.count)
                            if(viewModel.input == "help"){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "help", output: "help\t\t\tlist of all commands\nstatus\t\tdisplays the number of online players\nhostname\tchanges the name of the device\ncd\t\t\tchanges the working directory\nlst\t\t\tshows files of the current working directory\nl\t\t\tshows files of the current working directory\ndir\t\t\tshows files of the current working directory\ntouch\t\tcreate a file\ncat\t\t\treads out a file\nrm\t\t\tdeletes a file or a directory\ncp\t\t\tcopys a file\nmv\t\t\tmoves a file\nrename\t\trenames a file\nmkdir\t\tcreates a direcotry\nexit\t\t\tcloses the terminal or leaves another device\nquit\t\t\tcloses the terminal or leaves another device\nclear\t\tclears the terminal\nhistory\t\tshows the command history of the session\nmorphcoin\tshows wallet\npay\t\t\tsends money to another wallet\nservice\t\tcreates or uses services\nspot\t\t\tspots other devices\nconnect\t\tconnects to other device\nnetwork\t\ttype `network` for further information\ninfo\t\t\tshows info of the current device"))
                                viewModel.input = ""
                            }else if (viewModel.input == "clear") {
                                if(viewModel.output.count-1 == 0){
                                    viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "clear.", output:"There's nothing to clear"))
                                    viewModel.input = ""
                                }else{
                                    viewModel.output.removeSubrange(1...viewModel.output.count-1)
                                    viewModel.input = ""
                                }
                            }else if (viewModel.input == "service") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "service", output:"usage: service create | list | bruteforce | portscan"))
                                viewModel.input = ""
                                
                            }else if (viewModel.input == "service list") {
                                viewModel.list()
                                viewModel.input = ""
                                
                            }else if (viewModel.input == "service create portscan") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input , output:""))
                                viewModel.create(name: "portscan")
                                viewModel.input = ""
                                
                            }else if (viewModel.input == "service create telnet") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input , output:""))
                                viewModel.create(name: "telnet")
                                viewModel.input = ""
                                
                            }else if (viewModel.input == "service create bruteforce") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input , output:""))
                                viewModel.create(name: "bruteforce")
                                viewModel.input = ""
                                
                            }else if (viewModel.input == "service create ssh") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input , output:""))
                                viewModel.create(name: "ssh")
                                viewModel.input = ""
                                
                            }else if (viewModel.input == "service create") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input , output:"usage: service create\n <bruteforce|portscan|telnet|ssh>"))
                                viewModel.input = ""
                                
                            }else if (viewModel.input == "status") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "status", output:"Online players: \(viewModel.online)"))
                                viewModel.input = ""
                                
                            }else if (viewModel.input.contains("hostname") && viewModel.input.count > 24){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input, output:"The hostname couldn't be changed"))
                                viewModel.input = ""

                            }else if (regexHost.firstMatch(in: viewModel.input, options: [], range: range) != nil) {
                                let lineItems = viewModel.input.split(separator: " ", maxSplits: 1)
                                viewModel.changeHost(new: String(lineItems[1]))
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input, output:""))
                                viewModel.input = ""
                                
                            }else if(viewModel.input == "hostname"){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input, output: viewModel.device))
                                viewModel.input = ""
                            }else if (viewModel.input.contains("hostname")){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input, output:"The hostname couldn't be changed"))
                                viewModel.input = ""

                            }else if (viewModel.input == "spot"){
                                viewModel.spot()
                                viewModel.input = ""

                            }else{
                                
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "\(viewModel.input)", output: "Command could not be found.\nType `help` for a list of commands."))
                                viewModel.input = ""
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
