//
//  AddBill.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 27.11.2023.
//

import SwiftUI

struct AddBill: View {
    @ObservedObject var BillingModel : BillingViewModel
    @State var roomNumber = ""
    @State var payment = ""
    var billTypes = ["TL","USD","EURO"]
    @State var selectedBillType = "TL"
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text("ADD BILL")
                .font(.system(size: 24,weight: .black))
            HStack{
                TextField("Room Number", text: $roomNumber)
                .padding()
                .frame(width:150,height: 35)
                .border(.black)
                .keyboardType(.numberPad)
                TextField("Payment", text: $payment)
                    .padding()
                    .frame(height: 35)
                    .border(.black)
                    .keyboardType(.numberPad)
                Picker("", selection: $selectedBillType) {
                    ForEach(billTypes,id: \.self) { bill_type in
                        Text("\(bill_type)")
                    }
                }.border(.black)
            }
            
            Button {
                if !roomNumber.isEmpty && !payment.isEmpty {
                    BillingModel.makeBill(room_num: Int(roomNumber)!, payment: Int(payment)!, bill_type: selectedBillType)
                    BillingModel.bills = []
                    BillingModel.getBills(selectedDate: Date())
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Proceed")
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
                    .font(.system(size: 24,weight: .light))
                    .cornerRadius(12)
                    .padding(.top)
            }

            
            Spacer()
            
        }.padding(.horizontal)
            .padding(.top,50)
    }
}

struct AddBill_Previews: PreviewProvider {
    static var previews: some View {
        AddBill(BillingModel: BillingViewModel())
    }
}
