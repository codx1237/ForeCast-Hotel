//
//  MyTabView.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 8.10.2023.
//

import SwiftUI
import FirebaseFirestore

struct MyTabView: View {
    
    @State var isLandingPage = true
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        if isLandingPage{
            LandingPage()
                .onChange(of: networkMonitor.isConnected, perform: { connection in
                    isLandingPage = false
                })
                .onAppear{
                if networkMonitor.isConnected == false {
                    isLandingPage = true
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        isLandingPage = false
                    }
                }

            }
        } else {
            TabView{
                ContentView()
                    .tabItem {
                        VStack{
                            Text("Home")
                            Image(systemName: "house.fill")
                        }
                    }
                AddReservationVC()
                    .tabItem {
                        VStack{
                            Text("Add Reservation")
                            Image(systemName: "plus.app")
                        }
                    }
                ReservationsVC()
                    .tabItem {
                        VStack{
                            Text("Reservations")
                            Image(systemName: "calendar.badge.clock")
                        }
                    }
                BillingVC()
                    .tabItem {
                        VStack{
                            Text("Billing")
                            Image(systemName: "creditcard")
                        }
                    }
            }
        }

    }
    
}

struct MyTabView_Previews: PreviewProvider {
    static var previews: some View {
        MyTabView()
    }
}
