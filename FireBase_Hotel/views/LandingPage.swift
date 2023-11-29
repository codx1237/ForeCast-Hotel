//
//  LandingPage.swift
//  FireBase_Hotel
//
//  Created by Fırat Ören on 26.11.2023.
//

import SwiftUI
import AVKit

struct LandingPage: View {
    @State var isAnimated = false
    var body: some View {
        VStack{
            Image("logo").resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .offset(y: isAnimated ? 0 : -400)
            
        }.onAppear{
            withAnimation(Animation.linear(duration: 0.5)) {
                isAnimated.toggle()
            }
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
