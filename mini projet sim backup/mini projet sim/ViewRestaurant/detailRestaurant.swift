//
//  detailRestaurant.swift
//  mini projet sim
//
//  Created by youssef benhissi on 08/12/2020.
//

import SwiftUI

import SDWebImageSwiftUI

struct Detail : View {
    @Binding var selected : Restaurant
    @Binding var show : Bool
    @State var galeriebool = false
    @State var locationbool = false
    @StateObject var PlatModel = PlatViewModel()
    @State private var agreedToTerms = false
    @State private var agreedToTermsString = false
     var body: some View{
        
         VStack{
             
             VStack{
                 
                 ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                     
                    AnimatedImage(url: URL(string: selected.image)!)
                         .resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(height: 330)
                         .clipShape(RoundedShape(corners: [.bottomLeft,.bottomRight]))
                        // .matchedGeometryEffect(id: selected.img, in: animation)
                     
                     HStack{
                         
                         Button(action: {
                            self.locationbool = true
                             //withAnimation(.spring()){show.toggle()}
                             
                         }) {
                             
                             Image(systemName: "location.fill")
                                 .foregroundColor(.black)
                                 .padding()
                                 .background(Color.white)
                                 .clipShape(Circle())
                         }.sheet(isPresented: $locationbool) {
                            map()
                         }
                         
                         Spacer()
                         
                        Button(action: {
                           self.galeriebool = true
                        }) {
                            
                            Image(systemName: "photo.fill")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }.sheet(isPresented: $galeriebool) {
                          GalerieView(selectedRestaurant: $selected)
                       }
                     }
                     .padding()
                     // since all edges are ignored....
                     .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                 }
                 
                 // Details View...
                 
                 HStack(alignment: .top){
                     
                     VStack(alignment: .leading, spacing: 12) {
                         
                        Text(selected.name)
                             .font(.title)
                             .foregroundColor(Color("txt"))
                             .fontWeight(.bold)
                            // .matchedGeometryEffect(id: selected.title, in: animation)
                         
                         VStack(spacing: 10){
                             
                            HStack(spacing: 5){
                             Text("Region:")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color("txt"))
                                Spacer()
                                Text(selected.region)
                               //  .matchedGeometryEffect(id: selected.country, in: animation)
                            }
                             HStack(spacing: 5){
                                 
                                Text("Adresse:")
                                    .font(.title3)
                                   .fontWeight(.bold)
                                   .foregroundColor(Color("txt"))
                                 
                                Spacer()
                                Text(selected.adresse)
                             }
                         }
                     }
                     
                     Spacer(minLength: 0)
                     
                     
                 }
                 .padding()
                 .padding(.bottom)
             }
             .background(Color.white)
             .clipShape(RoundedShape(corners: [.bottomLeft,.bottomRight]))
             
             // ScrollView For Smaller Size Phones....
             
             if UIScreen.main.bounds.height < 750{
                 
                 ScrollView(.vertical, showsIndicators: false) {
                     
                     BottomView(selected: $selected)
                 }
             }
             else{
                 
                 BottomView(selected: $selected)
             }
             
             Spacer(minLength: 0)
         }
         .background(Color("bg-2"))
     }
 }
struct RoundedShape : Shape {
      
      // for resuable.....
      var corners : UIRectCorner
      
      func path(in rect: CGRect) -> Path {
          
          let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 45, height: 45))
          
          return Path(path.cgPath)
      }
  }
  
 struct BottomView : View {
    @StateObject var PlatModel = PlatViewModel()
    @Binding var selected : Restaurant
    @State var customAlert = false
    @State var galeriebool = false
     @State var index = 1
     var body: some View{
         
         VStack(alignment: .leading, spacing: 15) {
            
            
            
             /*Text("People")
                 .font(.title)
                 .fontWeight(.bold)
                 .foregroundColor(Color("txt"))
             
             Text("Member Of Your Group")
                 .font(.caption)
             */
             /*HStack(spacing: 15){
                 
                 ForEach(1...5,id: \.self){i in
                     
                     Button(action: {index = i
                        PlatModel.ajouterRating(idResto: Int(selected.id)!, idUser: 8, nbretoiles: i, nbrfois: 99, somme: 99)
                        
                     }) {
                         
                         Text("\(i)")
                             .fontWeight(.bold)
                             .foregroundColor(index == i ? .white : .gray)
                             .padding(.vertical,10)
                             .padding(.horizontal)
                             .background(Color("Color").opacity(index == i ? 1 : 0.07))
                             .cornerRadius(4)
                     }
                 }
                 
                 Spacer(minLength: 0)
             }
             .padding(.top)*/
            ReactionRestaurantView(PlatModel: PlatModel, selected: $selected)
                .padding(.leading)
             Text("Description")
                 .font(.title)
                 .fontWeight(.bold)
                 .foregroundColor(Color("txt"))
                 .padding(.top,10)
             
            Text(selected.description)
                 .multilineTextAlignment(.leading)
             
             Spacer(minLength: 0)
             
             HStack{
                 
                 Spacer(minLength: 0)
                 
                 Button(action: {
                    PlatModel.ajouterReservation(idResto: Int(selected.id)!, idUser: 8, email: "youssef.benhissi@esprit.tn")
                    self.customAlert = true
                 }) {
                     
                     Text("Reserver une Place")
                         .fontWeight(.bold)
                         .foregroundColor(.white)
                         .padding(.vertical)
                         .frame(width: UIScreen.main.bounds.width - 100)
                         .background(Color("Color"))
                         .clipShape(Capsule())
                 }.sheet(isPresented: $customAlert) {
                    CustomAlertView(show: $customAlert, message: $PlatModel.resvationString)
                }
                 
                 Spacer(minLength: 0)
             }
             .padding(.top)
             // since all edges are ignored...
             .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 15 : UIApplication.shared.windows.first?.safeAreaInsets.bottom)
             
         }
         .padding([.horizontal,.top])
     }
 }
 
