//
//  ContentView.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 1.10.2023.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    
    //let rooms = [101,102,104,105,106,201,202,203,204,205,301,302,303,304,305,306]
    
    let columns : [GridItem] = [
        GridItem(.flexible(),spacing: 0, alignment: nil),
        GridItem(.flexible(),spacing: 0, alignment: nil)
    ]
    
   @StateObject var staysViewModel = StayObservableObject()
    
    var body: some View {
        VStack{
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(staysViewModel.stays) { stay in
                            cardView(staysViewModel: staysViewModel, stay: stay)
                            }
                        }
                    }.navigationTitle("Oren Hotel")
                }
        }.onAppear{
//            Firestore.firestore().collection("OrenHotel/Reservation/stay").document("201").setData([
//                "name" : "" ,
//                "country" : "" ,
//                "check-in" : "" ,
//                "check-out" : "" ,
//                "room_price" : 0 ,
//                "total_guest" : 0
//            ])
        }
    }
    }


struct cardView : View {
    
    @ObservedObject var staysViewModel: StayObservableObject
    var stay: StayModel
    @State var isSheet = false
    @State var isAvail = false
    var body: some View {
        Text("Room \(stay.roomNum)")
            .padding()
            .frame(width: 180,height: 150)
            .background(isAvail ? .red : .green)
            .cornerRadius(12)
            .foregroundColor(.black)
            .bold()
            .font(.system(size: 24))
            .shadow(radius: 8)
            .onAppear{
                if stay.guestName.isEmpty {
                    isAvail = true
                } else {
                    isAvail = false
                }
            }
            .onTapGesture {
                isSheet.toggle()
            }
            .sheet(isPresented: $isSheet) {
                if isAvail {
                    AddStayVC(roomId: stay.roomNum, stay: staysViewModel ,isSheet: $isSheet)
                } else {
                    ViewWhoStaysVC(guest: stay, stayViewModel: staysViewModel, isSheet: $isSheet)
                }
                
            }
            
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
