//
//  ReservationsVC.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 10.10.2023.
//

import SwiftUI
import FirebaseFirestore

struct ReservationsVC: View {
   
    
   @State var isSheet = false
   @ObservedObject var reservationsModel = ReservationsModel()
    
    var body: some View {
        NavigationView {
            List{
                Section {
                    ForEach(reservationsModel.reservations,id: \.self) { rezz in
                        HStack{
                            VStack(alignment: .leading,spacing: 5){
                                Text("\(rezz.rez_name.uppercased())")
                                    .font(.system(size: 19))
                                    .bold()
                                Text("\(rezz.rez_country.uppercased())")
                                    .font(.system(size: 15))
                                Text("\(numberOfDaysBetween(from:rezz.rez_checkindate,to:rezz.rez_checkoutdate)) Nights")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Text("\(rezz.rez_totalGuest) Guest")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Text("\(rezz.rez_roomType) Room")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Text("\(calcTotalPrice(price:rezz.rez_roomPrice,lenghtOfStay:numberOfDaysBetween(from: rezz.rez_checkindate, to: rezz.rez_checkoutdate))) ₺")
                                    .foregroundColor(.gray)
                                Text("Recieved in \(getDateFormat(date:rezz.rez_recieved))")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            Text("\(getDateFormat(date: rezz.rez_checkindate))")
                                .foregroundColor(.blue)
                                .frame(width:110)
                                .lineLimit(2)
                                
                        }
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isSheet.toggle()
                        }

                    }.onDelete { IndexSet in
                        for indexx in IndexSet {
                            let rezId = reservationsModel.reservations[indexx].rez_id
                            reservationsModel.deleteRez(rezId: rezId,index:IndexSet)
                            print(indexx)
                        }
                        
                        
                    }
                    
                } header: {
                    Text("Reservations")
                }
            }.sheet(isPresented: $isSheet) {
                Text("qsad")
        }
        }.onAppear{
            reservationsModel.reservations = []
            reservationsModel.getRez()
        }
    }
    
    func calcTotalPrice(price: Int,lenghtOfStay: Int) -> Int{
        return price * lenghtOfStay
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
    
    func numberOfDaysBetween(from: String, to: String) -> Int {
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

struct ReservationsVC_Previews: PreviewProvider {
    static var previews: some View {
        ReservationsVC()
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}


