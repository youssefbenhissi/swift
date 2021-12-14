//
//  Accueil.swift
//  mini projet sim
//
//  Created by youssef benhissi on 23/11/2020.
//

import SwiftUI

struct Accueil: View {
    @State var search = ""
          @State var selectedMenu = "All"
          @State var selected : Item = items[0]
          @Namespace var animation
          @State var show = false
        
    var body: some View{
        ZStack{
                   
                   VStack{
                       
                       HStack{
                           
                           Text("Dashboard")
                               .font(.title)
                               .fontWeight(.bold)
                               .foregroundColor(.white)
                           
                           Spacer()
                           
                           Button(action: {}) {
                               
                               ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                                   
                                   Image(systemName: "bell")
                                       .font(.system(size: 25))
                                       .foregroundColor(.white)
                                   
                                   
                                   Circle()
                                       .fill(Color.red)
                                       .frame(width: 12, height: 12)
                               }
                           }
                       }
                       .padding()
                       
                       HStack(spacing: 15){
                           
                           Image(systemName: "magnifyingglass")
                               .font(.title2)
                               .foregroundColor(.white)
                           
                           TextField("Search", text: $search)
                               .preferredColorScheme(.dark)
                       }
                       .padding()
                       .background(Color("search"))
                       .cornerRadius(15)
                       .padding()
                       
                       HStack(spacing: 0){
                           
                           ForEach(menus,id: \.self){title in
                               
                               MenuButton(title: title, selected: $selectedMenu)
                               
                               // giving space for all expect for last...
                               
                               if title != menus.last{
                                   
                                   Spacer(minLength: 0)
                               }
                           }
                       }
                       .padding()
                       
                       ScrollView(.vertical, showsIndicators: false) {
                           
                           VStack(spacing: 15){
                               
                               ForEach(items){item in
                                   
                                   CardView(item: item)
                                       .shadow(color: Color.black.opacity(0.16), radius: 5, x: 0, y: 5)
                                       .onTapGesture {
                                           
                                           withAnimation(.spring()){
                                               
                                               selected = item
                                               show.toggle()
                                           }
                                       }
                               }
                           }
                           .padding(.horizontal,22)
                       }
                       .padding(.vertical)
                       .background(
                           Color("detailBg")
                               .clipShape(CustomCorner(corners: [.topLeft,.topRight], size: 55))
                               .ignoresSafeArea(.all, edges: .bottom)
                               .padding(.top,100)
                       )
                   }
                   
                  
               }
               .background(Color("bg").ignoresSafeArea(.all, edges: .all))
           }
    }


struct Accueil_Previews: PreviewProvider {
    static var previews: some View {
        Accueil()
    }
}

var menus = ["All","Sofa","Park bench","ArmChair"]
  
  struct MenuButton : View {
      
      var title : String
      @Binding var selected : String
      
      var body: some View{
          
          Button(action: {selected = title}) {
              
              Text(title)
                  .font(.system(size: 15))
                  .fontWeight(selected == title ? .bold : .none)
                  .foregroundColor(selected == title ? .white : Color.white.opacity(0.7))
                  .padding(.vertical,10)
                  .padding(.horizontal,20)
                  .background(Color("search").opacity(selected == title ? 1 : 0))
                  .cornerRadius(10)
          }
      }
  }
  
  // Custom Corner View...
  
  struct CustomCorner : Shape {
      
      var corners : UIRectCorner
      var size : CGFloat
      
      func path(in rect: CGRect) -> Path {
          
          let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: size, height: size))
          
          return Path(path.cgPath)
      }
  }
  
  // Card View...
  
  struct CardView : View {
      
      var item : Item
      
      var body: some View{
          
          ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
              
              HStack(spacing: 15){
                  
                  Text(item.title)
                      .font(.title3)
                      .fontWeight(.bold)
                      .foregroundColor(.black)
                  
                  Spacer(minLength: 0)
                  
                  Image(item.image)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                  // max Size...
                      .frame(height: 180)
                      //.matchedGeometryEffect(id: item.image)
              }
              .padding(.horizontal)
              .padding(.bottom)
              .background(Color.white.cornerRadius(25).padding(.top,35))
              .padding(.trailing,8)
              .background(Color.orange.cornerRadius(25).padding(.top,35))
              
              Text(item.price)
                  .foregroundColor(Color.black.opacity(0.6))
                  .padding(.vertical,10)
                  .padding(.horizontal,35)
                  .background(Color("Color1"))
                  .clipShape(CustomCorner(corners: [.topRight,.bottomLeft], size: 15))
          }
      }
  }
  
  // Model And Model Data...
  
  struct Item : Identifiable {
      
      var id = UUID().uuidString
      var image : String
      var title : String
      var price : String
  }
  
var items = [
  
      Item(image: "r1", title: "Classic Leather Arm Chair",price: "56$"),
      Item(image: "r2", title: "Poppy Plastic Tub Chair",price: "100$"),
     // Item(image: "r3", title: "Bar Stool Chair",price: "120$"),
  ]
  
  

