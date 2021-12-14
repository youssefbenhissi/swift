//
//  ReactionRestaurantView.swift
//  mini projet sim
//
//  Created by youssef benhissi on 02/01/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReactionRestaurantView: View {
    @StateObject var PlatModel = PlatViewModel()
    @Binding var selected : Restaurant
    @State var customAlert = false
    
    var body: some View {
        HStack(spacing: 15){
                    
                    ForEach(0...4,id: \.self){gif in
                        
                        // Enlarging GIF Reaction...
                        Button(action: {
                            
                            PlatModel.ajouterRating(idResto: Int(selected.id)!, idUser: 8, nbretoiles: (selected.sommeRating+gif)/(selected.nbrFois+1), nbrfois: selected.nbrFois+1, somme: selected.sommeRating+gif)
                            self.customAlert = true
                        })
                        {AnimatedImage(name: reactions[gif])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)}
                        .sheet(isPresented: $customAlert) {
                           CustomAlertView(show: $customAlert, message: $PlatModel.ratingString)
                       }
                            
                    }
                }
                .padding(.vertical,10)
                .padding(.horizontal,20)
                .background(Color.white.clipShape(Capsule()))
        
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: 5)
    }
}
var reactions = ["like.gif","love.gif","haha.gif","wow.gif","sad.gif","angry.gif"]
struct ReactionRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        //ReactionRestaurantView(, selected: )
        LiquidSwipeView()
    }
}
