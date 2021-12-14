//
//  cardViewRestaurantDuJour.swift
//  mini projet sim
//
//  Created by youssef benhissi on 02/01/2021.
//

import SwiftUI

struct cardViewRestaurantDuJour: View {
    
    @EnvironmentObject var model : CarouselViewModel
    var animation: Namespace.ID
    var card: CardRestaurantDuJour
    var body: some View {
        VStack{
            Text("Monday 28 December")
                            .font(.caption)
                            .foregroundColor(Color.white.opacity(0.85))
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding()
                            .padding(.top,10)
            HStack {
                            Text(card.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 250, alignment: .leading)
                                .padding()
                                
                            Spacer(minLength: 0)
                        }
            Spacer(minLength: 0)
            HStack{
                            
                            Spacer(minLength: 0)
                            
                            
                                
                                Text("Read More")
                                
                                Image(systemName: "arrow.right")
                            
                        }
                        .foregroundColor(Color.white.opacity(0.9))
                        .padding(30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(card.cardColor
                        .cornerRadius(25)
                        .matchedGeometryEffect(id: "bgColor-\(card.id)", in: animation)
                            )
        
        
    }
}

struct cardViewRestaurantDuJour_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
