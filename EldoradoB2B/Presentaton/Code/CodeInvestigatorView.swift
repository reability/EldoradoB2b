//
//  CodeInvestigatorView.swift
//  EldoradoB2B
//
//  Created by Ванурин Алексей Максимович on 22.06.2021.
//

import SwiftUI
import Firebase

protocol CodeInvestigatorViewDelegate {
    func addItem(_ item: Jobitem)
}

struct CodeInvestigatorView: View {
    
    @State private var item: Jobitem?
    @State private var enteredPhone = ""
    @State private var entereditem: Jobitem?
    
    var delegate: CodeInvestigatorViewDelegate?
    
    @ViewBuilder
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 4, content: {
                Text("Вбить код").font(.system(size: 32, weight: .light, design: .default))
                TextField("0000", text: $enteredPhone) { _ in
                    
                } onCommit: {
                    onCommit()
                }.frame(width: 340.0, height: 30.0, alignment: .center).background(Color(red: 249/255, green: 249/255, blue: 249/255, opacity: 1.0)).cornerRadius(10.0)
                
                if let item = item {
                            JobitemCard(model: item)
                            Button(action: onComplete, label: {
                                Text("Добавить").padding(8.0).frame(width: 340.0, height: 50.0, alignment: .center).foregroundColor(.white).font(.system(size: 14, weight: .bold, design: .default))
                            }).background(Color.green).cornerRadius(10.0)
                }
                
            }).background(Color.clear)
        }.background(Color.clear).padding(.all, 20.0)}
    
    func onComplete() {
        delegate?.addItem(self.item!)
    }
    
    func onCommit() {
        let code = Int(enteredPhone)!
        
        var firebase: DatabaseReference!
        
        firebase = Database.database().reference()
        
        firebase.child("Items/").getData { (error, snapshot) in
            (snapshot.value as? NSArray)?.forEach({ data in
                if let data = data as? NSDictionary {
                    guard let id = data["code"] as? Int,
                          let name = data["name"] as? String,
                          let price = data["cPrice"] as? Int,
                          let url = data["img"] as? String
                          else { return }
                    
                    let newItem = Jobitem(title: name, id: id, image: url, price: price)
                    if id == code {
                        self.item = newItem
                        return
                    }
                }
            })
        }
        
    }
    
}
