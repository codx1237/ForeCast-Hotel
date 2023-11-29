//
//  ViewWhoStaysVC.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 5.11.2023.
//

import SwiftUI
import FirebaseFirestore

struct ViewWhoStaysVC: View {

    enum AlertTypes {
        case checkout
        case saved
    }
    
    var guest : StayModel
    @ObservedObject var stayViewModel : StayObservableObject
    @Binding var isSheet : Bool
    @State var totalpricebtn = false
    @State var totalPrice = 0
    @State var isAlert = false
    @State private var myAlert : AlertTypes?

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12){
                Text("Room \(guest.roomNum)")
                    .font(.system(size: 24))
                HStack{
                    Text("Guest Name")
                    Spacer()
                    Text("\(guest.guestName)")
                        .foregroundColor(.blue)
                }.padding(.horizontal)
                HStack{
                    Text("Guest Country")
                    Spacer()
                    Text("\(guest.guestCountry)")
                        .foregroundColor(.blue)
                }.padding(.horizontal)
                HStack{
                    Text("Check-in")
                    Spacer()
                    Text("\(getDateFormat(date:guest.guestCheckin))")
                        .foregroundColor(.blue)
                }.padding(.horizontal)
                HStack{
                    Text("Check-out")
                    Spacer()
                    Text(" \(getDateFormat(date:guest.guestCheckout)) ")
                        .foregroundColor(.blue)
                }.padding(.horizontal)
                HStack{
                    Text("Total Guest")
                    Spacer()
                    Text(" \(guest.totalGuest) ")
                        .foregroundColor(.blue)
                }.padding(.horizontal)
                HStack{
                    Text("Length Of Stay")
                    Spacer()
                    Text(" \(numberOfDaysBetween(from:guest.guestCheckin,to:guest.guestCheckout)) ")
                        .foregroundColor(.blue)
                }.padding(.horizontal)
                HStack{
                    Text("Room Price")
                    Spacer()
                    Text("\(guest.roomPrice) TL")
                        .foregroundColor(.blue)
                }.padding(.horizontal)
                
                VStack{
                    Button {
                        let checkoutdate = !guest.guestCheckout.isEmpty ? guest.guestCheckout : "\(Date())"
                        let numberOfDays = numberOfDaysBetween(from: guest.guestCheckin, to: checkoutdate)
                        totalPrice = (numberOfDays * guest.roomPrice)
                        totalpricebtn.toggle()

                    } label: {
                        Text("Total Price")
                            .frame(width: 120)
                            .padding()
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            
                    }
                    NavigationLink {
                        EditStayView(guest: guest, stayViewModel: stayViewModel)
                    } label: {
                        Text("Edit")
                            .frame(width: 120)
                            .padding()
                            .background(.black)
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }

//                    Button {
//
//                    } label: {
//                        Text("Edit")
//                            .frame(width: 120)
//                            .padding()
//                            .background(.black)
//                            .foregroundColor(.blue)
//                            .cornerRadius(8)
//
//                    }
                    Button {
                        let stringtoDate = stringToDate(st: guest.guestCheckout)
                        let newDate = Calendar.current.date(byAdding: DateComponents(day: 1), to: stringtoDate)
                        if let newDate = newDate {
                            stayViewModel.addStay(roomNum: guest.roomNum, guestName: guest.guestName, guestCountry: guest.guestCountry, guestCheckin: guest.guestCheckin, guestCheckout: "\(newDate)", guestTotal: guest.totalGuest, roomPrice: guest.roomPrice)
                            stayViewModel.stays = []
                            stayViewModel.getStays()
                        }

                        
                    } label: {
                        Text("+1 Day")
                            .frame(width: 120)
                            .padding()
                            .background(.black)
                            .foregroundColor(.green)
                            .cornerRadius(8)
                            
                    }
                    Button {
                        isAlert.toggle()
                        myAlert = .checkout
                    } label: {
                        Text("Check-Out")
                            .frame(width: 120)
                            .padding()
                            .background(.black)
                            .foregroundColor(.red)
                            .cornerRadius(8)
                            .padding(.bottom,50)
                    }
                    
                    if totalpricebtn {
                        Text("Total Price is : \(totalPrice) TL")
                    }
                    
                    
                }.padding(.top)
                
                            
                Spacer()
            }
            .alert(isPresented: $isAlert){
                getAlerts()
            }
        .padding(.top)
        }

    }
    
    func getAlerts() -> Alert {
        switch myAlert {
        case .checkout :
           let alert = Alert(
            title: Text("Check-Out"),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .default(Text("Check-Out")){
                stayViewModel.checkOutGuest(roomNum: guest.roomNum)
                stayViewModel.stays = []
                stayViewModel.getStays()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isSheet = false
                }
            })
            return alert
        case .saved :
            let alert = Alert(
                title: Text("Save"),
                primaryButton: .cancel(Text("Cancel")),
                secondaryButton: .default(Text("Save")){
                    print("Saved")
                    
                })
            
             return alert
        case .none:
            let alert = Alert(title: Text("Alert"))
            return alert
        }
    }
    
    func getDateFormat(date : String) -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate]
        let date = isoDateFormatter.date(from: date)
        let newDate = Calendar.current.dateComponents([.year,.month,.day], from: date!)
        let newYear  = newDate.year ?? 2023
        let newMonth = newDate.month
        let newDay   = newDate.day ?? 1
        
        switch newMonth {
        case 1:
            return "\(newDay) January \(newYear) "
        case 2:
            return "\(newDay) February \(newYear) "
        case 3:
            return "\(newDay) March \(newYear) "
        case 4:
            return "\(newDay) April \(newYear) "
        case 5:
            return "\(newDay) May \(newYear) "
        case 6:
            return "\(newDay) June \(newYear) "
        case 7:
            return "\(newDay) July \(newYear) "
        case 8:
            return "\(newDay) August \(newYear) "
        case 9:
            return "\(newDay) September \(newYear) "
        case 10:
            return "\(newDay) October \(newYear) "
        case 11:
            return "\(newDay) November \(newYear) "
        case 12:
            return "\(newDay) December \(newYear) "
        default :
            return ""
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
    
    func stringToDate(st: String) -> Date {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate]
        let date = isoDateFormatter.date(from: st)
        return date!
    }
}


struct ViewWhoStaysVC_Previews: PreviewProvider {
    static var previews: some View {
        ViewWhoStaysVC(guest: StayModel(roomNum: 101, guestName: "FIRAT", guestCountry: "TURKEY", guestCheckin: "4 NOV 2023", guestCheckout: "-", totalGuest: 3, roomPrice: 100), stayViewModel: StayObservableObject(), isSheet: .constant(false))
    }
}
