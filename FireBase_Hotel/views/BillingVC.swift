//
//  BillingVC.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 26.11.2023.
//

import SwiftUI


struct BillingVC: View {
    @State var date = Date()

    @StateObject var billingModel = BillingViewModel()
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    Image("logo").resizable().frame(width: 40,height: 40).clipShape(Circle())
                        .padding(.trailing)
                    Spacer()
                    NavigationLink {
                        AddBill(BillingModel: billingModel)
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                    }

                }.padding(.horizontal)

                Divider()
                Text("Billing")
                    .font(.system(size: 24,weight: .bold))
                
                DatePicker(selection: $date,in: ...Date.now ,displayedComponents: .date){
                    Text("Select a Date")
                        .fontWeight(.ultraLight)
                }.padding(.horizontal)
                Button {
                    billingModel.bills = []
                    DispatchQueue.main.async {
                        billingModel.getBills(selectedDate: date)
                    }
                    
                } label: {
                    Text("Proceed")
                }

                VStack{
                    HStack(){
                        Text("Room")
                            .frame(width: UIScreen.main.bounds.width/3)
                            .underline(color: .black)
                        Text("Price")
                            .frame(width: UIScreen.main.bounds.width/3)
                            .underline(color: .black)
                        Text("Date")
                            .frame(width: UIScreen.main.bounds.width/3)
                            .underline(color: .black)
                    }
                    .padding(.top)
                    .padding(.bottom)
                    .font(.system(size: 19,weight: .light))
                    
                    ScrollView{
                        ForEach(billingModel.bills) { bill in
                                HStack(){
                                    Text("\(bill.roomNum)")
                                        .frame(width: UIScreen.main.bounds.width/3)
                                    Text("\(bill.payment) TL")
                                        .frame(width: UIScreen.main.bounds.width/3)
                                    Text("\(bill.date)")
                                        .frame(width: UIScreen.main.bounds.width/3)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    print(bill.roomNum)
                                }
                            Divider()
                        }
                        HStack{
                            Spacer()
                            Text("Total: \(totalPaymen(myArray:billingModel.bills))")
                        }.padding(.trailing).padding(.top)
                    }

                }

                
                Spacer()
            }
        }

    }
    func totalPaymen(myArray: [Bill]) -> Int {
        var total = 0
        for arr in myArray {
            total += arr.payment
        }
        return total
    }
    
}

struct BillingVC_Previews: PreviewProvider {
    static var previews: some View {
        BillingVC()
    }
}

