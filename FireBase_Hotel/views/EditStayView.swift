//
//  EditStayView.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 24.11.2023.
//

import SwiftUI

struct EditStayView: View {
    var guest : StayModel
    @ObservedObject var stayViewModel : StayObservableObject
    @State var guest_name = ""
    @State var guest_country = ""
    @State var guest_checkin = Date()
    @State var guest_checkout = Date()
    @State var guest_total = ""
    @State var room_price = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack{
            Text("Room \(guest.roomNum)")
                .font(.system(size: 24,weight: .black,design: .serif))
            VStack(alignment :.leading){
                TextField("Guest Name", text: $guest_name)
                    .padding()
                    .frame(width: 200,height: 30)
                Divider()
                .frame(height: 1)
                .padding(.horizontal,30)
                
                TextField("Guest Country", text: $guest_country)
                    .padding()
                    .frame(width: 200,height: 30)
                Divider()
                .frame(height: 1)
                .padding(.horizontal,30)
                
                DatePicker(selection: $guest_checkin,in: ...Date.now ,displayedComponents: .date){
                    Text("Select a Check-in Date")
                        .fontWeight(.ultraLight)
                }.padding(.horizontal)
                
                Divider()
                .frame(height: 1)
                .padding(.horizontal,30)
                
                DatePicker(selection: $guest_checkout,in: Date.now... ,displayedComponents: .date){
                    Text("Select a Check-out Date")
                        .fontWeight(.ultraLight)
                }.padding(.horizontal)
                
                TextField("Total Guest", text: $guest_total)
                    .keyboardType(.numberPad)
                    .padding()
                    .frame(width: 200,height: 30)
    
                Divider()
                .frame(height: 1)
                .padding(.horizontal,30)
                
                TextField("Room Price", text: $room_price)
                    .keyboardType(.numberPad)
                    .padding()
                    .frame(width: 200,height: 30)
            }
            
            Button {
                let stringCheckin = "\(guest_checkin)"
                let stringCheckout = "\(guest_checkout)"
                if !guest_name.isEmpty && !guest_country.isEmpty && !guest_total.isEmpty && !room_price.isEmpty {
                    if numberOfDaysBetween(from: stringCheckin, to: stringCheckout) > 0 {
                        stayViewModel.addStay(roomNum: guest.roomNum, guestName: guest_name.capitalized, guestCountry: guest_country.capitalized, guestCheckin: stringCheckin, guestCheckout: stringCheckout, guestTotal: Int(guest_total)!, roomPrice: Int(room_price)!)
                        stayViewModel.stays = []
                        stayViewModel.getStays()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 05) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    } else {
                        print("invalid dates")
                    }
                } else {
                    print("pls fill the fields")
                }
            } label: {
                Text("Save")
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
                    .font(.system(size: 19,weight: .regular))
            }


            Spacer()
            
        }
    }
    
    func numberOfDaysBetween(from: String, to: String ) -> Int {

        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate]
        let from = isoDateFormatter.date(from: from)
        let to   = isoDateFormatter.date(from: to)
        let fromDate = Calendar.current.startOfDay(for: from!)
        let toDate = Calendar.current.startOfDay(for: to!)
        let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        return numberOfDays.day!
    }
    
}

struct EditStayView_Previews: PreviewProvider {
    static var previews: some View {
        EditStayView(guest: StayModel(roomNum: 101, guestName: "FIRAT", guestCountry: "TURKIYE", guestCheckin: "", guestCheckout: "", totalGuest: 1, roomPrice: 600), stayViewModel: StayObservableObject())
    }
}
