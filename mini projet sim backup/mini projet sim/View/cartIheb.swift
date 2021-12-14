//
//  cartIheb.swift
//  mini projet sim
//
//  Created by youssef benhissi on 08/12/2020.
//
//CardView

import SwiftUI
import SDWebImageSwiftUI
struct CardIheb: View {
    var item : Restaurant
    var body: some View {
        
        HStack{
            
            AnimatedImage(url: URL(string: item.image)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width / 3.2)
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text(item.name)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Text(item.price)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(item.price)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
            }
            
            Spacer(minLength: 0)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 5, y: 5)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: -5, y: -5)
    }
}
