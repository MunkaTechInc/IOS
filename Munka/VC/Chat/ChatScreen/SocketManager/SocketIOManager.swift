//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Puneet Sharma on 10/12/19.


import UIKit
import SocketIO
class SocketIOManager: NSObject {
    
    /*
    1)send_message   send message 
    2)get_message   receive chat messages
    */
  //  http://192.168.2.85:3000/
    
    static let manager = SocketManager(socketURL: URL(string: "http://admin.munkainc.com:3000")!)
    static let socket = manager.defaultSocket
    static let sharedInstance = SocketIOManager()
    
    
    func establishConnection(){
        SocketIOManager.socket.connect()
        SocketIOManager.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            print("socket connect data",data)
        }
    }
    
    func closeConnection(){
        SocketIOManager.socket.disconnect()
    }
}
