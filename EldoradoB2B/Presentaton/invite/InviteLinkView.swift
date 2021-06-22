//
//  InviteLinkView.swift
//  EldoradoB2B
//
//  Created by Ванурин Алексей Максимович on 22.06.2021.
//

import SwiftUI
import CoreImage.CIFilterBuiltins


struct Worker {
    let id: Int
    let name: String
    let links: [SocialLink]
    
    static var stub: Worker {
        return Worker(id: 1, name: "Хабиб", links: [
            .init(title: "fd", value: "fddf"),
            .init(title: "fddf", value: "fddfdf")
        ])
    }
    
}

struct SocialLink: Identifiable {
    let id = UUID()
    let title: String
    let value: String
}

struct InviteLinkView: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State var codeString: String
    @State var items: [Jobitem]
    @State var worker: Worker
    
    var body: some View {
        ScrollView {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 4, content: {
                Text("\(codeString)").font(.system(size: 18, weight: .bold, design: .default))
                Image(uiImage: generateQRCode(from: "\(codeString)"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                Text("Ваши товары").font(.system(size: 18, weight: .bold, design: .default))
                ForEach(items) {
                    JobitemCard(model: $0)
                        .background(Color.white).padding()
                        .shadow(color: Color.black.opacity(0.07), radius: 20, x: 4, y: 4)
                }
                Text("Контактная информация").font(.system(size: 18, weight: .bold, design: .default))
                HStack(alignment: .firstTextBaseline, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                    Text("\(worker.name)").multilineTextAlignment(.leading).font(.system(size: 14, weight: .regular, design: .default))
                })
                ForEach(worker.links) { link in
                    HStack(alignment: .firstTextBaseline, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                        Text("\(link.title)").multilineTextAlignment(.leading).font(.system(size: 14, weight: .light, design: .default))
                        Text("\(link.value)").multilineTextAlignment(.leading).font(.system(size: 14, weight: .light, design: .default))
                    })
                }
                
            })
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
