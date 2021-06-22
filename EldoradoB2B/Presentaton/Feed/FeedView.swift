//
//  FeedView.swift
//  EldoradoB2B
//
//  Created by Ванурин Алексей Максимович on 20.06.2021.
//

import SwiftUI
import Firebase

struct FeedView: View {
    @State private var jobs = [JobStatusCard]()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20, content:
                    {
                        UserBar()
                        Text("История").multilineTextAlignment(.leading)
                        ForEach(jobs) {
                            JobCard(model: $0)
                        }
                    }).padding(0.0).onAppear(perform: {
                        fetch()
                    })
        }
    }
    
    
    func fetch() {
        var firebase: DatabaseReference!
        
        firebase = Database.database().reference()
        
        firebase.child("Jobs").getData { (error, snapshot) in
            var cards = [JobStatusCard]()
            (snapshot.value as? NSDictionary)?.forEach({ data in
                if let data = data.value as? NSDictionary {
                    var jobs =  [Jobitem]()
                    if let items = data["items"] as? NSArray {
                        for item in items {
                            let id = (item as! NSDictionary)["Id"] as! Int
                            let title = (item as! NSDictionary)["title"] as! String
                            let price = (item as! NSDictionary)["price"] as! Int
                            let url = (item as! NSDictionary)["img"] as! String
                            jobs.append(.init(title: title, id: id, image: url, price: price))
                        }
                    }
                    cards.append(.init(title: "dfdf", items: jobs, status: .checkOuted))
                }
            })
            jobs = cards
        }
    }
}
