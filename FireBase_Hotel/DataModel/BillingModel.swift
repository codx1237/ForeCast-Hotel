//
//  BillingModel.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 26.11.2023.
//

import Foundation
import FirebaseFirestore

struct Bill: Identifiable {
    let id : String = UUID().uuidString
    let roomNum : Int
    let payment : Int
    let billType : String
    let date : String
    let bill_id : String
}

class BillingViewModel : ObservableObject {
    private let db = Firestore.firestore()
    @Published var bills : [Bill] = [Bill]()

    
    init(){
        getBills(selectedDate: Date())
    }
    
    func getBills(selectedDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        let newSelectedDate = dateFormatter.string(from: selectedDate)
       // newDate = stringToDate(st: newDate)
        
        db.collection("OrenHotel/Billing/bill").getDocuments { querySnapshot, error in
            if error == nil {
                for document in querySnapshot!.documents {
                        let data = document.data()
                        let bill_date = data["date"] as? String ?? ""
                    print(newSelectedDate)
                    if bill_date == newSelectedDate {
                        let bill_room = data["room_num"] as? Int ?? 0
                        let bill_payment = data["payment"] as? Int ?? 0
                        let bill_type = data["bill_type"] as? String ?? ""
                        let bill_id = document.documentID
                        print(bill_room)
                        self.bills.append(Bill(roomNum: bill_room, payment: bill_payment,billType: bill_type, date: bill_date,bill_id: bill_id))
                    }
                        
                }
            }
        }
    }
    
    func makeBill(room_num: Int,payment: Int,bill_type: String){
        db.collection("OrenHotel/Billing/bill").document().setData([
            "room_num": room_num,
            "payment" : payment,
            "bill_type": "\(bill_type)",
            "date" : "\(formatDate(date: Date()))"
        ]) { err in
            if let err = err {
                print("error writing document\(err)")
            } else {
                print("success")
            }
            
        }
    }
    
    
    func formatDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        
        return dateFormatter.string(from: date)
    }
    
}
