//
//  newItemView.swift
//  EldoradoB2B
//
//  Created by Ванурин Алексей Максимович on 20.06.2021.
//

import SwiftUI

protocol newItemDelegate {
    func newItem(_ item: Jobitem)
}

struct newItemView: View {
    var delegate: newItemDelegate
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            ScrollView {
            Text("Телевизор Samsung QE55Q77AAU")
            Image("tvPl")
                .resizable()
                .scaledToFit()
            Text("Цена 33 000 Р (+1399 бонусов)")
            Button(action: onFinish, label: {
                    Text("Добавить")
                })
            }
        })
    }
    
    func onFinish() {
        delegate.newItem(Jobitem(title: "Телевизор Samsung QE55Q77AAU", id: 0, image: "plTv", price: 33000))
    }
}

