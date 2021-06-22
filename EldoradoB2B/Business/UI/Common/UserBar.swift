//
//  UserBar.swift
//  EldoradoB2B
//
//  Created by Ванурин Алексей Максимович on 20.06.2021.
//

import SwiftUI

struct UserBar: View {
    var body: some View {
        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Image("userAvatar")
                .resizable()
                .scaledToFit()
                .frame(width: 56.0, height: 56.0)
            VStack() {
                Text("Андрей Сергеевич").multilineTextAlignment(.leading)
                Text("Младший консультант").multilineTextAlignment(.leading)
            }
        })
    }
}

struct UserBar_Previews: PreviewProvider {
    static var previews: some View {
        UserBar()
    }
}
