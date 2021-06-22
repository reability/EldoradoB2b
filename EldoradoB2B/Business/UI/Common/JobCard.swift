//
//  JobCard.swift
//  EldoradoB2B
//
//  Created by Ванурин Алексей Максимович on 20.06.2021.
//

import SwiftUI

enum JobStatus {
    case checkOuted
}

struct JobStatusCard: Identifiable {
    let id = UUID()
    var title: String
    var items: [Jobitem]
    var status: JobStatus
    
    static var stub: JobStatusCard {
        return JobStatusCard(title: "Test Title", items: [Jobitem.stub, Jobitem.stub, Jobitem.stub, Jobitem.stub], status: .checkOuted)
    }
    
    func getFinalPrice() -> Int {
        let summa: Int = items.reduce(0, { $0 + $1.price })
        
        return summa
    }
    
    func getBonuses() -> Int {
        return Int(0.23 * Float(getFinalPrice()))
    }
    
}

struct JobCard: View {
    
    @State var model: JobStatusCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0, content: {
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                switch model.status {
                case .checkOuted:
                    Image("greenLight")
                }
            Text("Оплачено").font(.system(size: 12, weight: .light, design: .default))
            }
            )
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text("# 128-7890993").font(.system(size: 16, weight:.bold, design: .default))
                Spacer()
                Text("28.07.2021 16:21").font(.system(size: 14, weight: .light, design: .default))
            })
            Text("Время консультации: 21 минута").font(.system(size: 14, weight: .light, design: .default))
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10.0, content: {
                if model.items.count > 3 {
                    Group  {
                        ImageView(withURL: model.items[0].image)
                    }
                    .frame(width: 96.0, height: 96.0)
                    .background(Color.gray)
                    .cornerRadius(10.0)
                    
                    Group  {
                        ImageView(withURL: model.items[1].image)
                    }
                    .frame(width: 96.0, height: 96.0)
                    .background(Color.gray)
                    .cornerRadius(10.0)
                    
                    Group  {
                        Text("Еще +\(String(model.items.count - 2))")
                        .padding()
                    }
                    .frame(width: 96.0, height: 96.0)
                    .background(Color.gray)
                    .cornerRadius(10.0)
                } else {
                    ForEach(model.items) { item in
                        Group  {
                            ImageView(withURL: item.image)
                        }
                        .frame(width: 96.0, height: 96.0)
                        .background(Color.gray)
                        .cornerRadius(10.0)
                    }
                }
            })
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text("Общая сумма").font(.system(size: 14, weight: .light, design: .default))
                Text("\(model.getFinalPrice()) р").font(.system(size: 14, weight: .light, design: .default))
            })
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text("Начислено").font(.system(size: 14, weight: .medium, design: .default))
                Text("+ \(model.getBonuses()) бонусов").font(.system(size: 14, weight: .medium, design: .default))
            })
        }).padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.07), radius: 5, x: 0, y: 4)
    }
}
