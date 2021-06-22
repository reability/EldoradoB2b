//
//  MasterViewController.swift
//  EldoradoB2B
//
//  Created by Ванурин Алексей Максимович on 20.06.2021.
//

import SwiftUI

struct MasterViewController: View {
    
    var pullUpPresented: Bool = false
    
    var body: some View {
        TabView {
            FeedView()
                .tabItem { Text("Главная") }
        }
        .overlay(
            PullMe()
        )
    }
    
    func openSession() {
        print("Open")
    }
    
}

struct MasterViewController_Previews: PreviewProvider {
    static var previews: some View {
        MasterViewController()
    }
}
