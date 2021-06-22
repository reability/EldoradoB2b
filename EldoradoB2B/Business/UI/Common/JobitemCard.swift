//
//  JobitemCard.swift
//  EldoradoB2B
//
//  Created by Ванурин Алексей Максимович on 20.06.2021.
//

import SwiftUI

struct JobitemCard: View {
    
    var model: Jobitem
    
    var body: some View {
        Group {
        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            ImageView(withURL: model.image)
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text(model.title).font(.system(size: 14, weight: .regular, design: .default))
                Text("\(model.price) ₽").font(.system(size: 16, weight: .bold, design: .default))
            })
        })
        }.cornerRadius(10.0)

    }
}
