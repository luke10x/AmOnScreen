import SwiftUI
import UserNotifications
import Foundation
import CoreFoundation

struct ContentView: View {

    let echoServer: EchoServer

    var body: some View {
        VStack {
            Image(systemName: "recordingtape")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("Recording")
        }
        .padding()
        
        .onAppear {

            var count = 0
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                
                let app = NSApplication.shared
                let windows = app.windows
                
                let window = windows.first
                window?.level = .popUpMenu
                
                count = count + 1
                
                if window?.isOnActiveSpace == true {
                    print("window is here " + String(count))
                    echoServer.shouldEchoProperty = true
                    
                } else {
                    print("window is not here " + String(count))
                    echoServer.shouldEchoProperty = false
                }
                
            }
            
            echoServer.start()
        }
        .onDisappear {
            print("stopping")
            echoServer.listener?.cancel()
            NSApplication.shared.terminate(self)
        }
    }
}

let echoServer = EchoServer()

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView(echoServer: echoServer)
    }
}
