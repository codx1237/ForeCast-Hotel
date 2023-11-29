//
//  StayObservableObject.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 16.11.2023.
//

import SwiftUI
import FirebaseFirestore

struct StayModel : Identifiable {
    var id : String = UUID().uuidString
    var roomNum : Int
    var guestName : String
    var guestCountry : String
    var guestCheckin : String
    var guestCheckout : String
    var totalGuest : Int
    var roomPrice : Int
    
}



class StayObservableObject : ObservableObject  {
   private var db = Firestore.firestore()
   @Published var stays : [StayModel] = [StayModel]()
   
    
    init(){
        getStays()
    }
    
    func getStays() {
        db.collection("OrenHotel/Reservation/stay").getDocuments { querySnapshot, error in
            if let error = error {
                print("error when getting the items\(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let guestName = data["name"] as? String ?? ""
                    let guestCountry = data["country"] as? String ?? ""
                    let guestCheckin = data["check-in"] as? String ?? "\(Date())"
                    let guestCheckout = data["check-out"] as? String ?? "\(Date())"
                    let guestTotal = data["total_guest"] as? Int ?? 1
                    let roomPrice = data["room_price"] as? Int ?? 100
                    let roomNum = Int(document.documentID)
                    
                    self.stays.append(StayModel(roomNum: roomNum!, guestName: guestName, guestCountry: guestCountry, guestCheckin: guestCheckin, guestCheckout: guestCheckout, totalGuest: guestTotal, roomPrice: roomPrice))
                }
            }
        }
    }
    
    func addStay(roomNum: Int, guestName: String, guestCountry: String, guestCheckin: String, guestCheckout: String, guestTotal: Int,roomPrice: Int){
        db.collection("OrenHotel/Reservation/stay").document("\(roomNum)").setData([
            "name": guestName,
            "country": guestCountry,
            "check-in": guestCheckin,
            "check-out": guestCheckout,
            "room_price": roomPrice,
            "total_guest": guestTotal
        ]) { err in
            if let err = err {
                print("Error writing the document\(err)")
            } else {
                print("item succesfully written")
               // isSheet = false
            }
        }
        
    }
    
    func checkOutGuest(roomNum: Int){
        db.collection("OrenHotel/Reservation/stay").document("\(roomNum)").setData([
            "name" : "" ,
            "country" : "" ,
            "check-in" : "" ,
            "check-out" : "" ,
            "room_price" : 0 ,
            "total_guest" : 0
        ]) { err in
            if let err = err {
                print("Error deleting the document\(err)")
            } else {
                print("item succesfully deleted")
               // isSheet = false
            }
        }
    }
    
    
}


