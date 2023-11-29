//
//  ReservationsModel.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 20.10.2023.
//

import Foundation
import FirebaseFirestore


struct Reservations : Hashable {
    
    var rez_id : String
    var rez_name : String
    var rez_country : String
    var rez_roomType : String
    var rez_totalGuest : Int
    var rez_roomPrice : Int
    var rez_checkindate : String
    var rez_checkoutdate : String
    var rez_recieved : String

}

class ReservationsModel : ObservableObject {
    
    @Published var reservations : [Reservations] = [Reservations]()
    let db = Firestore.firestore()
    
    init() {
       getRez()
    }
    
    func getRez(){
        db.collection("OrenHotel/Reservation/newRez").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let rez_name = data["rez_name"] as? String ?? ""
                    let rez_country = data["rez_country"] as? String ?? ""
                    let rez_roomType = data["rez_roomType"] as? String ?? ""
                    let rez_totalGuest = data["rez_totalGuest"] as? Int ?? 1
                    let rez_roomPrice = data["rez_roomPrice"] as? Int ?? 600
                    let rez_checkindate = data["rez_checkindate"] as? String ?? "\(Date())"
                    let rez_checkoutdate = data["rez_checkoutdate"] as? String ?? "\(Date())"
                    let rez_recieved = data["rez_recieved"] as? String ?? "\(Date())"
                    let rez_id = document.documentID
                    
                    self.reservations.append(Reservations(rez_id:rez_id,rez_name: rez_name, rez_country: rez_country, rez_roomType: rez_roomType, rez_totalGuest: rez_totalGuest, rez_roomPrice: rez_roomPrice , rez_checkindate: rez_checkindate,rez_checkoutdate: rez_checkoutdate, rez_recieved: rez_recieved))
                    
                    
                }
            }
        }
    }
    
    
    func makeRez(rez_name: String , rez_country: String , rez_roomType: String , rez_totalGuest : Int , rez_roomPrice : Int , rez_checkindate : String, rez_checkoutdate: String , rez_recieved: String) {
        db.collection("OrenHotel/Reservation/newRez").document().setData([
            "rez_name" : rez_name,
            "rez_country" : rez_country ,
            "rez_roomType" : rez_roomType ,
            "rez_totalGuest" : rez_totalGuest ,
            "rez_roomPrice" : rez_roomPrice ,
            "rez_checkindate" : rez_checkindate,
            "rez_checkoutdate" : rez_checkoutdate,
            "rez_recieved" : rez_recieved
        ]) { err in
            if let err = err {
                print("error writing document\(err)")
            } else {
                print("success")
            }
            
        }
    }
    
    func deleteRez(rezId: String,index: IndexSet){
        db.collection("OrenHotel/Reservation/newRez").document("\(rezId)").delete() { err in
            if let err = err {
              print("Error removing document: \(err)")
            } else {
              print("Document successfully removed!")
                self.reservations.remove(atOffsets: index)
                
            }
        }
    }

    
    
}






