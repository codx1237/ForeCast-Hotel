//
//  ReservationsVC.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 8.10.2023.
//

import SwiftUI
import FirebaseFirestore
import Combine

struct AddReservationVC: View {
    
    @State var checkin_date = Date.now
    @State var checkout_date : Date = Calendar.current.date(byAdding: DateComponents(day: 1), to: Date.now) ?? Date.now
    @State var rez_name = ""
    @State var rez_country = ""
    @State var rez_totalOfGuest = ""
    @State var rez_roomPrice = ""
    var roomTypes = ["SINGLE","DOUBLE","TWIN","TRIPLE"]
    var countryList = Countries()
    @State var selectedCountry = ""
    @State var selectedRoomType = ""
    @StateObject var reservationsModel = ReservationsModel()
    @State private var alert: AlertTypes? = nil
    @FocusState private var nameisFocused : Bool
    @FocusState private var totalGuestisFocused : Bool
    @FocusState private var totalPriceFocused : Bool
    @State var isKeyboardPresented = false
    
    var body: some View {
        
        VStack{
                Image("istanbul")
                .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.3)
                .animation(.easeOut)
                .ignoresSafeArea()
                .padding(.top,isKeyboardPresented ? -250 : 0)
                .padding(.bottom, 10)
                .blur(radius: isKeyboardPresented ? 1 : 0)
                .zIndex(1.0)
              
            ScrollView {
                VStack{
                        DatePicker(selection: $checkin_date, in: Date.now... ,displayedComponents: .date)
                        {
                            Text("Check-in:")
                                .font(.system(size: 18,weight: .medium))
                                .foregroundColor(.blue)
                        }
                        DatePicker(selection: $checkout_date, in: Date.tomorrow...,displayedComponents: .date){
                            Text("Check-out:")
                                .font(.system(size: 18,weight: .medium))
                                .foregroundColor(.blue)
                        }
                        HStack{
                            Text("Guest Name:")
                                .foregroundColor(.blue)
                                .font(.system(size: 18,weight: .medium))
                            Spacer()
                            TextField("Please Enter Name", text: $rez_name)
                                .focused($nameisFocused)
                                .padding(10)
                                .frame(width: 220,height: 30)
                                .background(Color.black.opacity(0.1))
                                .cornerRadius(12)
                                .font(.system(size: 15))
                        }
                    HStack{
                        Text("Total Guests:")
                            .foregroundColor(.blue)
                            .font(.system(size: 18,weight: .medium))
                        Spacer()
                        TextField("Please Enter Total of Guests", text: $rez_totalOfGuest)
                            .focused($totalGuestisFocused)
                            .padding(10)
                            .frame(width: 220,height: 30)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(12)
                            .keyboardType(.numberPad)
                            .font(.system(size: 15))
                    }
                    HStack{
                        Text("Guest Country:")
                            .foregroundColor(.blue)
                            .font(.system(size: 18,weight: .medium))
                        Spacer()
                        Picker("", selection: $selectedCountry) {
                            ForEach(countryList.countries.values.sorted(),id: \.self) {country in
                                Text(country)
                            }
                        }
                    }

                    HStack{
                        Text("Room Type:")
                            .foregroundColor(.blue)
                            .font(.system(size: 18,weight: .medium))
                        Spacer()
                        Picker("\(roomTypes[0])", selection: $selectedRoomType) {
                            ForEach(roomTypes , id: \.self) { roomType in
                                Text(roomType)
                            }
                        }
                    }

                        HStack{
                            Text("Room Price:")
                                .foregroundColor(.blue)
                                .font(.system(size: 18,weight: .medium))
                            Spacer()
                            TextField("Enter Price (TL)", text: $rez_roomPrice)
                                .focused($totalPriceFocused)
                                .padding(10)
                                .frame(width: 220,height: 30)
                                .background(Color.black.opacity(0.1))
                                .cornerRadius(12)
                                .keyboardType(.numberPad)
                                .font(.system(size: 15))
                        }
                        Button {
                           
                            let numberOfDays = numberOfDaysBetween(from: checkin_date, to: checkout_date)
                            
                            if numberOfDays >= 0 {
                                
                                if !rez_name.isEmpty && !selectedCountry.isEmpty && !selectedRoomType.isEmpty && !rez_totalOfGuest.isEmpty && !rez_roomPrice.isEmpty {
                                    
                                    selectedCountry = selectedCountry + flag(country: countryList.countries.allKeys(forValue: "\(selectedCountry)")[0])
                                    
                                    
                                    
                                    alert = .oneButton(title: "Success", message: "Reservation has succesfully been made" , dismissButton: .default(Text("Submit")){
                                        reservationsModel.makeRez(rez_name: rez_name, rez_country: selectedCountry, rez_roomType: selectedRoomType, rez_totalGuest: Int(rez_totalOfGuest) ?? 1, rez_roomPrice: Int(rez_roomPrice) ?? 1, rez_checkindate: "\(checkin_date)", rez_checkoutdate: "\(checkout_date)", rez_recieved: "\(Date())")
                                        refreshFields()
                                        
                                    })
                                } else {
                                    alert = .oneButton(title: "Error", message: "Please fill the empty fields", dismissButton: .destructive(Text("Ok")))
                                }
                            } else {
                                alert = .noButton(title: "Error Date", message: "heck-in and Check-out dates cannot be the same")
                            }
                            
                                

                            nameisFocused = false
                            totalPriceFocused = false
                            totalGuestisFocused = false
                            
   
                        } label: {
                            Text("Make Reservation")
                                .frame(width: 200,height: 25)
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .font(.system(size: 21,weight: .medium))
                            
                        }
                        
                        
                    }
                .onReceive(keyboardPublisher) { value in
                    isKeyboardPresented = value
                }
                    .padding(.horizontal)
                    .padding(.top, isKeyboardPresented ? 80 : 20)
                    .animation(.easeOut)
                    .alert(item: $alert) { value in
                        return value.alert
                        
                    }
                    .onAppear{
                        selectedCountry = countryList.countries["TR"]!
                        selectedRoomType = roomTypes[0]
                       
                    }
            }
                
                Spacer()
                
            
        }
    }

    
    func numberOfDaysBetween(from: Date, to: Date) -> Int {
        
        let fromDate = Calendar.current.startOfDay(for: from) // <1>
        let toDate = Calendar.current.startOfDay(for: to) // <2>
        let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate) // <3> start
        return numberOfDays.day!
    }

    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    func refreshFields(){
        rez_name = ""
        rez_country = ""
        rez_roomPrice = ""
        rez_totalOfGuest = ""
        checkin_date = Date()
        checkout_date = Calendar.current.date(byAdding: DateComponents(day: 1), to: Date.now) ?? Date()
    }
}

struct AddReservationVC_Previews: PreviewProvider {
    static var previews: some View {
        AddReservationVC()
    }
}

extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}

extension View {
  var keyboardPublisher: AnyPublisher<Bool, Never> {
    Publishers
      .Merge(
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillShowNotification)
          .map { _ in true },
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillHideNotification)
          .map { _ in false })
      .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
