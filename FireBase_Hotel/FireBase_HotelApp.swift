//
//  FireBase_HotelApp.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 1.10.2023.
//

import SwiftUI
import Firebase
@main
struct FireBase_HotelApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            
            MyTabView()
                .environmentObject(networkMonitor)
            
        }
    }
}
