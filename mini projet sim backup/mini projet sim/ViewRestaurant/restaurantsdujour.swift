//
//  restaurantsdujour.swift
//  mini projet sim
//
//  Created by youssef benhissi on 02/01/2021.
//

import SwiftUI
var width = UIScreen.main.bounds.width
struct restaurantsdujour: View {
    @EnvironmentObject var model: CarouselViewModel
    @Namespace var animation
    var body: some View {
        VStack {
            HStack{
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                })
                Text("Healthy tips")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.leading)
                Spacer()
            }
            .padding()
            Spacer()
            ZStack{
                ForEach(model.cardsRestaurantsDuJour.indices.reversed(),id: \.self){index in
                    HStack{
                        cardViewRestaurantDuJour(animation: animation, card: model.cardsRestaurantsDuJour[index])
                            .frame(width: getCardWidth(index: index), height: getCardHeight(index: index))
                            .offset(x: getCardOffset(index: index))
                            .rotationEffect(.init(degrees: getCardRotation(index: index)))
                        Spacer(minLength: 0)
                    }
                    .frame(height: 400)
                    .contentShape(Rectangle())
                    .offset(x: model.cardsRestaurantsDuJour[index].offset)
                    .gesture(DragGesture(minimumDistance: 0)
                                .onChanged({ (value) in
                                                                        onChanged(value: value, index: index)
                                                                    }).onEnded({ (value) in
                                                                        onEnd(value: value, index: index)
                                                                    }))
                    
                    
                }
            }
            .padding(.top , 25)
            .padding(.horizontal , 30)
            Button(action: ResetViews , label: {
                                
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.blue)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 3)
                            })
                            .padding(.top,35)
            Spacer()
            
        }
        
    }
    func ResetViews(){
            
            for index in model.cardsRestaurantsDuJour.indices{
                
                withAnimation(.spring()){
                    
                    model.cardsRestaurantsDuJour[index].offset = 0
                    model.swipedCard = 0
                }
            }
        }
    func getCardRotation(index: Int)->Double{
           
           let boxWidth = Double(width / 3)
           
           let offset = Double(model.cardsRestaurantsDuJour[index].offset)
           
           let angle : Double = 5
           
           return (offset / boxWidth) * angle
       }
    func onChanged(value: DragGesture.Value,index: Int){
           
           // Only Left Swipe...
           
           if value.translation.width < 0{
               
               model.cardsRestaurantsDuJour[index].offset = value.translation.width
           }
       }
    func onEnd(value: DragGesture.Value,index: Int){
        withAnimation{
                    
                    if -value.translation.width > width / 3{
                        
                        model.cardsRestaurantsDuJour[index].offset = -width
                        model.swipedCard += 1
                    }
                    else{
                        
                        model.cardsRestaurantsDuJour[index].offset = 0
                    }
                }
        
        }
    func getCardHeight(index : Int) -> CGFloat {
        let height : CGFloat = 400
                // Again First Three Cards...
                let cardHeight = index - model.swipedCard <= 2 ? CGFloat(index - model.swipedCard) * 35 : 70
                return height - cardHeight
    }
    func getCardWidth(index: Int)->CGFloat{
           
           let boxWidth = UIScreen.main.bounds.width - 60 - 60
           
           // For First Three Cards....
           //let cardWidth = index <= 2 ? CGFloat(index) * 30 : 60
           
           return boxWidth
       }
    func getCardOffset(index: Int)->CGFloat{
            
            return index - model.swipedCard <= 2 ? CGFloat(index - model.swipedCard) * 30 : 60
        }
}

struct restaurantsdujour_Previews: PreviewProvider {
    static var previews: some View {
        restaurantsdujour()
    }
}
