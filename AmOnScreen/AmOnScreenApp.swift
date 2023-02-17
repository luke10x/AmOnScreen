//
//  AmOnScreenApp.swift
//  AmOnScreen
//
//  Created by Luke English on 2/16/23.
//

import SwiftUI
import Network

@main
struct AmOnScreenApp: App {
    let echoServer = EchoServer()

    var body: some Scene {
        WindowGroup {
            ContentView(echoServer: echoServer)
        }
    }
}

class EchoServer {
    var listener: NWListener?
    var shouldEchoProperty: Bool = false
    
    init() {
        start()
    }
    
    func start() {
        do {
            listener = try NWListener(using: .tcp, on: 12345)
            listener?.stateUpdateHandler = { newState in
                switch newState {
                case .ready:
                    print("Listener started")
                case .failed(let error):
                    print("Listener failed with error: \(error)")
                default:
                    break
                }
            }
            listener?.newConnectionHandler = { [weak self] newConnection in
                print("New connection accepted")
                newConnection.start(queue: .global(qos: .userInitiated))
                self?.handleConnection(newConnection)
            }
            listener?.start(queue: .global(qos: .userInitiated))
        } catch {
            print("Failed to start listener with error: \(error)")
        }
    }
    
    func handleConnection(_ connection: NWConnection) {
        let response = shouldEchoProperty ? "OK" : "NO"
        let responseData = Data(response.utf8)
        connection.send(content: responseData, completion: .contentProcessed({ error in
            if let error = error {
                print("Failed to send response with error: \(error)")
                return
            }
            connection.cancel()
        }))
    }
}
