//
//  TerminalView.swift
//  cryptic
//
//  Created by Nils Grob on 11.01.21.
//

import SwiftUI

struct TerminalView: View {
    @ObservedObject var viewModel:TerminalViewModel
    //@State var output:[TerminalOutput] = []
    let socket:Socket
    
    init(socket:Socket) {
        self.socket = socket
        self.viewModel = TerminalViewModel(socket: socket)
        let formatter = DateFormatter()
        formatter.dateFormat = "eeeeee, dd.MM.yyyy"
        self.viewModel.output.append((TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "", output:[Row(id: UUID(), contentBeforeUUID: "Last login: \(formatter.string(from:(Date(milliseconds: Int64(viewModel.lastLogin)))))", uuid: "", contentAfterUUID: "")])))
      
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
                                HStack(alignment: .top, spacing: 0){
                                    Spacer().frame(width: 20)
                                    Text("\(output.username)@\(output.deviceName)").foregroundColor(.green).font(.footnote)
                                    Text(":").foregroundColor(.white).font(.footnote)
                                    Text("\(output.path)").foregroundColor(.blue).font(.footnote)
                                    Text("$").foregroundColor(.green).font(.footnote)
                                    Text("\(output.command)").foregroundColor(.white).font(.footnote)
                                    Spacer()
                                }
                                //HStack(spacing: 0){
                                  //  Spacer().frame(width: 20)
                                 
                                    ForEach(output.output){ row in
                                        HStack(){
                                            Spacer().frame(width: 20)
                                            Text("\(row.contentBeforeUUID)").foregroundColor(.white).font(.footnote)
                                            Text("\(row.uuid)").underline().onTapGesture{viewModel.input = viewModel.input + " " + row.uuid}.foregroundColor(.white).font(Font.system(size: 5)) 
                                            Text("\(row.contentAfterUUID)").foregroundColor(.white).font(.footnote)
                                            Spacer()
                                        }
                                            }
                                        //}
                                    
                                    Spacer()
                                
                               
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
                            let regexTouch = try! NSRegularExpression(pattern: "touch [a-zA-Z1-9]{1,63} [a-zA-Z0-9]{0,255}")
                            let regexCat = try! NSRegularExpression(pattern: "cat [a-zA-Z]{1,63}")
                            let range = NSRange(location: 0, length: viewModel.input.utf16.count)
                            if(viewModel.input == "help"){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "help", output: [Row(id: UUID(), contentBeforeUUID: "help\t\t\tlist of all commands", uuid: "", contentAfterUUID: ""),Row(id: UUID(), contentBeforeUUID: "status\t\tdisplays the number of online players", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "hostname\tchanges the name of the device", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "cd\t\t\tchanges the working directory", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "ls\t\t\tshows files of the current working directory", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "l\t\t\tshows files of the current working directory", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "dir\t\t\tshows files of the current working directory", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "touch\t\tcreate a file", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "cat\t\t\treads out a file", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "rm\t\t\tdeletes a file or a directory", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "cp\t\t\tcopys a file", uuid: "", contentAfterUUID: ""),Row(id: UUID(), contentBeforeUUID: "mv\t\t\tmoves a file", uuid: "", contentAfterUUID: ""),Row(id: UUID(), contentBeforeUUID: "rename\t\trenames a file", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "mkdir\t\tcreates a direcotry", uuid: "", contentAfterUUID: ""),Row(id: UUID(), contentBeforeUUID: "exit\t\t\tcloses the terminal or leaves another device", uuid: "", contentAfterUUID: ""),Row(id: UUID(), contentBeforeUUID: "quit\t\t\tcloses the terminal or leaves another device", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "clear\t\tclears the terminal", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "history\t\tshows the command history of the session", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "morphcoin\tshows wallet", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "pay\t\t\tsends money to another wallet", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "service\t\tcreates or uses services", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "spot\t\t\tspots other devices", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "connect\t\tconnects to other device", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "network\t\ttype `network` for further information", uuid: "", contentAfterUUID: ""), Row(id: UUID(), contentBeforeUUID: "info\t\t\tshows info of the current device", uuid: "", contentAfterUUID: "")]))
                                viewModel.input = ""
                            }else if (viewModel.input == "clear") {
                                if(viewModel.output.count-1 == 0){
                                    viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "clear.", output:[Row(id: UUID(), contentBeforeUUID: "There's nothing to clear", uuid: "", contentAfterUUID: "")]))
                                    viewModel.input = ""
                                }else{
                                    viewModel.output.removeSubrange(1...viewModel.output.count-1)
                                    viewModel.input = ""
                                }
                            }else if (viewModel.input == "service") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "service", output:[Row(id: UUID(), contentBeforeUUID: "usage: service create | list | bruteforce | portscan", uuid: "", contentAfterUUID: "")]))
                                viewModel.input = ""

                            }else if (viewModel.input == "service list") {
                                viewModel.listServices()
                                viewModel.input = ""

                            }else if (viewModel.input == "service create portscan") {
                                viewModel.create(name: "portscan")
                                

                            }else if (viewModel.input == "service create telnet") {
                                viewModel.create(name: "telnet")

                            }else if (viewModel.input == "service create bruteforce") {
                                viewModel.create(name: "bruteforce")
                                

                            }else if (viewModel.input == "service create ssh") {
                                viewModel.create(name: "ssh")
                                

                            }else if (viewModel.input == "service create") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input , output:[Row(id: UUID(), contentBeforeUUID: "usage: service create\n <bruteforce|portscan|telnet|ssh>", uuid: "", contentAfterUUID: "")]))
                                viewModel.input = ""

                            }else if (viewModel.input == "status") {
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "status", output:[Row(id: UUID(), contentBeforeUUID: "Online players: \(viewModel.online)", uuid: "", contentAfterUUID: "")]))
                                viewModel.input = ""

                            }else if (viewModel.input.contains("hostname") && viewModel.input.count > 24){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input, output:[Row(id: UUID(), contentBeforeUUID: "The hostname couldn't be changed", uuid: "", contentAfterUUID: "")]))
                                viewModel.input = ""

                            }else if (regexHost.firstMatch(in: viewModel.input, options: [], range: range) != nil) {
                                let lineItems = viewModel.input.split(separator: " ", maxSplits: 1)
                                viewModel.changeHost(new: String(lineItems[1]))
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input, output:[Row(id: UUID(), contentBeforeUUID: "", uuid: "", contentAfterUUID: "")]))
                                viewModel.input = ""

                            }else if(viewModel.input == "hostname"){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input, output:[Row(id: UUID(), contentBeforeUUID: viewModel.device, uuid: "", contentAfterUUID: "")]))
                                viewModel.input = ""
                            }else if (viewModel.input.contains("hostname")){
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input, output:[Row(id: UUID(), contentBeforeUUID: "The hostname couldn't be changed", uuid: "", contentAfterUUID: "")]))
                                viewModel.input = ""

                            }else if (viewModel.input == "spot"){
                                viewModel.spot()
                                viewModel.input = ""

                            }else if (viewModel.input == "ls"){
                                viewModel.list()
                            }else if (viewModel.input == "l"){
                                viewModel.list()
                            }else if (regexTouch.firstMatch(in: viewModel.input, options: [], range: range) != nil) {
                                let lineItems = viewModel.input.split(separator: " ", maxSplits: 2)
                                viewModel.touch(name: String(lineItems[1]), content: lineItems.count == 3 ? String(lineItems[2]) : "")
                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: viewModel.input, output:[Row(id: UUID(), contentBeforeUUID: "create file with name", uuid: "", contentAfterUUID: "\(lineItems[1])"), Row(id: UUID(), contentBeforeUUID: "and content:", uuid: "", contentAfterUUID: "\(lineItems.count == 3 ? lineItems[2] : "")")]))
                                viewModel.input = ""

                            }else if (regexCat.firstMatch(in: viewModel.input, options: [], range: range) != nil) {
                                let lineItems = viewModel.input.split(separator: " ", maxSplits: 1)
                                viewModel.cat(name: String(lineItems[1]))
                            }else{

                                viewModel.output.append(TerminalOutput(id: UUID(), username: viewModel.user, deviceName: viewModel.device, path: viewModel.path, command: "\(viewModel.input)", output: [Row(id: UUID(), contentBeforeUUID: "Command could not be found.\nType `help` for a list of commands.", uuid: "", contentAfterUUID: "")]))
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
