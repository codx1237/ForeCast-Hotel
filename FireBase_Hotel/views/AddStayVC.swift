//
//  AddStayVC.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 5.11.2023.
//

import SwiftUI
import FirebaseFirestore

struct AddStayVC: View {
    let roomId: Int
    @ObservedObject var stay : StayObservableObject
    @State var guest_name = ""
    @State var guest_country = ""
    @State var checkin = Date.now
    @State var checkout : Date = Calendar.current.date(byAdding: DateComponents(day: 1), to: Date.now) ?? Date.now
    @State var room_price = ""
    @State var total_guest = ""
    @Binding var isSheet : Bool
    @State var isAlert = false
    @State var myAlert : AlertTypes?
    
    enum AlertTypes {
        case saved
        case fail
    }
    
    var body: some View {
        VStack{
            Text("Room \(roomId)")
                .font(.system(size: 24))
            HStack{
                Text("Guest Name")
                Spacer()
                TextField("", text: $guest_name)
                    .frame(width: 200,height: 30)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.characters)
                    
            }.padding(.horizontal)
            HStack{
                Text("Guest Country")
                Spacer()
                TextField("", text: $guest_country)
                    .frame(width: 200,height: 30)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.characters)
            }.padding(.horizontal)
            HStack{
                Text("Check-in")
                Spacer()
                DatePicker(selection: $checkin,in: ...Date.now ,displayedComponents: .date){}
            }.padding(.horizontal)
            HStack{
                Text("Check-out")
                Spacer()
                DatePicker(selection: $checkout,in: Date.now... ,displayedComponents: .date){}
            }.padding(.horizontal)
            HStack{
                Text("Room Price")
                Spacer()
                TextField("", text: $room_price)
                    .frame(width: 200,height: 30)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }.padding(.horizontal)
            HStack{
                Text("Total Guest")
                Spacer()
                TextField("", text: $total_guest)
                    .frame(width: 200,height: 30)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    
            }.padding(.horizontal)
            
            Button {
                let stringCheckin = "\(checkin)"
                let stringCheckout = "\(checkout)"
                if !guest_name.isEmpty && !guest_country.isEmpty &&  !String(room_price).isEmpty && !String(total_guest).isEmpty {
                    if numberOfDaysBetween(from: stringCheckin, to: stringCheckout) > 0 {
                        myAlert = .saved
                        isAlert.toggle()
                    }
                } else {
                    myAlert = .fail
                    isAlert.toggle()
                }
                
            } label: {
                Text("Save")
                    .padding()
                    .frame(width: 120)
                    .background(.black)
                    .foregroundColor(.white)
                    .padding(.top)
            }

            
            Spacer()
        }.padding(.top)
            .alert(isPresented: $isAlert) {
                switch myAlert {
                case .saved :
                    let alert = Alert(title: Text("Save"),
                                      primaryButton: .cancel(Text("Cancel")),
                                      secondaryButton: .default(Text("Save")){
                        stay.addStay(roomNum: roomId, guestName: guest_name, guestCountry: guest_country, guestCheckin: "\(checkin)", guestCheckout: "\(checkout)", guestTotal: Int(total_guest)!, roomPrice: Int(room_price)!)
                        stay.stays = []
                        stay.getStays()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isSheet = false
                        }
                    })
                    return alert
                case .fail :
                    let alert = Alert(title: Text("Error"),
                                      message: Text("Please fill all the missing fields"),
                                      dismissButton: .destructive(Text("Ok"))
                                      )
                    return alert
                case .none :
                    let alert = Alert(title: Text("none"))
                    return alert
                }
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

struct AddStayVC_Previews: PreviewProvider {
    static var previews: some View {
        AddStayVC(roomId: 101, stay: StayObservableObject(), isSheet: .constant(false))
    }
}
