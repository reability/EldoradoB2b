//
//  JobView.swift
//  EldoradoB2B
//
//  Created by Ванурин Алексей Максимович on 20.06.2021.
//

import SwiftUI
import CodeScanner
import FirebaseDatabase
import UIKit
import Combine

protocol JobViewDelegate: class {
    func code()
}


enum JobViewModal: Identifiable {
    case codeScanner, catalog, itemPicker, result, codeInvestigator
    
    var id: Int {
        hashValue
    }
}

struct Jobitem: Identifiable {
    var title: String
    var id: Int
    var image: String
    var price: Int
    
    static var stub: Jobitem {
        return Jobitem(title: "Телевизор Samsung QE55Q77AAU", id: 0, image: "plTv", price: 33000)
    }
    
}

var workerGlobal: Worker!

struct JobView: View, newItemDelegate, CodeInvestigatorViewDelegate {
    
    @State private var model: [Jobitem] = []
    
    @State private var activeModal: JobViewModal?
    @State private var showingAlert = false
    @State private var itemToShow = "dfdfdf"
    
    @State private var toggled: Bool = false
    @State private var enteredPhone = ""
    @State private var enteredEmail = ""
    
    @State private var jobCode: String!
    @State private var workerObj: Worker!
    
    @ViewBuilder
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12.0, content: {
                Text("Шаг 1").font(.system(size: 14, weight: .light, design: .default))
                HStack(alignment: .firstTextBaseline, spacing: 20.0, content: {
                    Text("Добавить товар").font(.system(size: 18, weight: .bold, design: .default))
                    Spacer()
                    Button(action: addFromList, label: {
                        Image("filter")
                    })
                    Button(action: addFromSearch, label: {
                        Image("barcode")
                    })
                })
                
                Group {
                    if model.isEmpty {
                        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                            Text("Тут пока пусто")
                            Spacer()
                        })
                    }
                    ForEach(model) {
                        JobitemCard(model: $0)
                            .padding()
                            .background(Color.white)
                            .shadow(color: Color.black.opacity(0.07), radius: 20, x: 4, y: 4)
                    }
                }
                Divider()
                Text("Шаг 2").font(.system(size: 14, weight: .light, design: .default))
                Text("Укажите пожелания покупателей").font(.system(size: 18, weight: .bold, design: .default))
                Divider()
                Group {
                    
                    Text("Шаг 3").font(.system(size: 14, weight: .light, design: .default))
                    Text("Контактные данные").font(.system(size: 18, weight: .bold, design: .default))
                    Toggle("Зарегестрированный пользователь", isOn: $toggled)
                    Text("Телефон").font(.system(size: 14, weight: .regular, design: .default))
                    TextField("+ 7 (000) - 000 - 00 - 00", text: $enteredPhone).frame(width: 340.0, height: 50.0, alignment: .center).background(Color(red: 249/255, green: 249/255, blue: 249/255, opacity: 1.0)).cornerRadius(10.0)
                    Text("Email").font(.system(size: 14, weight: .light, design: .default))
                    TextField("Введите e-mail", text: $enteredEmail).frame(width: 340.0, height: 50.0, alignment: .center).background(Color(red: 249/255, green: 249/255, blue: 249/255, opacity: 1.0)).cornerRadius(10.0)
                    Text("Сохранить код").font(.system(size: 14, weight: .light, design: .default))
                    Button(action: onFinish, label: {
                        Text("Сгенерировать код").padding(8.0).frame(width: 340.0, height: 50.0, alignment: .center).foregroundColor(.black).font(.system(size: 14, weight: .bold, design: .default))
                    }).background(Color(red: 249/255, green: 249/255, blue: 249/255, opacity: 1.0)).cornerRadius(10.0)
                    Button(action: onFinish, label: {
                        Text("Завершить").padding(8.0).frame(width: 340.0, height: 50.0, alignment: .center).foregroundColor(.white).font(.system(size: 14, weight: .bold, design: .default))
                    }).background(Color.green).cornerRadius(10.0)
                }
            })
        }
        .onAppear(perform: {
            onAppear()
        })
        .padding(16)
        .sheet(item: $activeModal) {
            self.activeModal = nil
        } content: { item in
            switch item {
            case .codeScanner:
                CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
            case .catalog:
                newItemView(delegate: self)
            case .itemPicker:
                newItemView(delegate: self)
            case .result:
                InviteLinkView(codeString: self.jobCode, items: self.model, worker: workerGlobal)
            case .codeInvestigator:
                CodeInvestigatorView(delegate: self )
            }
        }
        
    }
    
    func addItem(_ item: Jobitem) {
        self.model.append(item)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            activeModal = nil
            
        }
        
    }
    
    func setupWorker(worker: Worker) {
        workerGlobal = worker
    }
    
    func onAppear() {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        self.jobCode = String((0..<8).map{ _ in letters.randomElement()! })
        
    }
    
    func addFromList() {
        activeModal = .codeInvestigator
    }
    
    func addFromSearch() {
        activeModal = .codeScanner
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        activeModal = nil
        load(code: Int(try! result.get())!)
        print(try! result.get())
        
        //itemToShow = "asw"
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //activeModal = .itemPicker
        //}
    }
    
    func onFinish() {
        push()
    }
    
    func newItem(_ item: Jobitem) {
        load(code: 1234)
    }
    
    func fetchuser() {
        
    }
    
    func load(code: Int) {
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
                        self.model.append(newItem)
                        return
                    }
                }
            })
        }
        
    }
    
    func push() {
        var firebase: DatabaseReference!
        firebase = Database.database().reference()
        
        firebase.child("workers").getData { (e, s) in
            (s.value as? NSArray)?.forEach({ data in
                if let data = data as? NSDictionary {
                    guard let id = data["id"] as? Int else { return }
                    
                    if id == 1 {
                        let workerData = data
                        
                        if let _id = data["id"] as? Int,
                           let name = data["name"] as? String,
                           let links = data["links"] as? NSArray {
                            
                            var nemp = [SocialLink]()
                            for link in links {
                                if let link = link as? NSDictionary,
                                   let t = link["title"] as? String,
                                   let v = link["value"] as? String {
                                    nemp.append(SocialLink(title: t, value: v))
                                }
                            }
                            self.setupWorker(worker: Worker(id: _id, name: name, links: nemp))
                        }
                        
                        
                        
                        var itemsList = [[String: Any]]()
                        for item in self.model {
                            let temp = [
                                "Id": item.id,
                                "title": item.title,
                                "price": item.price,
                                "img": item.image,
                            ] as [String : Any]
                            itemsList.append(temp)
                        }
                        
                        let m = [
                            "code": self.jobCode!,
                            "items": itemsList,
                            "worker": workerData
                        ] as [String: Any]
                        
                        
                        firebase.child("Jobs").child(jobCode).setValue(m)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            activeModal = .result
                        }
                    }
                    
                }
            })
        }
        
    }
    
}
