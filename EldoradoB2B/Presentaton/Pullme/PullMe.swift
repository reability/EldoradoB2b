//
//  PullMe.swift
//  EldoradoB2B
//
//  Created by Ванурин Алексей Максимович on 20.06.2021.
//

import SwiftUI
struct PullMe: View {
    
    private var snapPoint: [CGFloat] = [
        40.0,
        UIScreen.screenHeight / 2.0,
        660.0,
    ]
    
    @State private var shouldUpdateHeight: Bool = false
    
    @State private var currentHeight: CGFloat = 660.0
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                Text("Текущая консультация").font(.system(size: 24, weight: .bold, design: .default)).padding(EdgeInsets(top: 8.0, leading: 16.0, bottom: 10.0, trailing: 18.0))
                    .gesture(DragGesture()
                                .onChanged({ value in onChageHeight(with: value.translation.height)})
                                .onEnded({ value in onEndDrag(with: value.translation.height)}))
                JobView()
                Spacer()
            })
            .border(Color.black.opacity(0.5), width: 1.0)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.07), radius: 20, x: 4, y: 4)
            .cornerRadius(10.0)
            
        }
        .padding(.top, currentHeight).animation(Animation.default.speed(shouldUpdateHeight ? 1 : .infinity))
        
    }
    
    // MARK: - Actions
    
    func onChageHeight(with value: CGFloat) {
        shouldUpdateHeight = false
        currentHeight += value
    }
    
    func onEndDrag(with velue: CGFloat) {
        var newHeight: CGFloat = 0.0
        shouldUpdateHeight = true
        if currentHeight > snapPoint.last! {
            newHeight = snapPoint.last!
        } else if currentHeight < snapPoint.first! {
            newHeight = snapPoint.first!
        } else {
            if currentHeight > snapPoint[1] {
                if abs(currentHeight - snapPoint[1]) < abs(currentHeight - snapPoint[0]) {
                    newHeight = snapPoint[1]
                } else {
                    newHeight = snapPoint[0]
                }
            } else {
                if abs(currentHeight - snapPoint[2]) < abs(currentHeight - snapPoint[1]) {
                    newHeight = snapPoint[2]
                } else {
                    newHeight = snapPoint[1]
                }
            }
        }
        currentHeight = newHeight
    }
}
