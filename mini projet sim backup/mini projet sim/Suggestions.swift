//
//  Favorites.swift
//  mini projet sim
//
//  Created by youssef benhissi on 23/11/2020.
//

import SwiftUI

struct Favorites: View {
    @State var search = ""
    @State var isModal: Bool = false
        @State var selectedTab = "Home"
        var body: some View {
           
            VStack{
                
                HStack{
                    
                    Button(action: {
                        
                    }
                    ) {
                        Image("outland")
                            .font(.title)
                            .foregroundColor(.black)
                    }.sheet(isPresented: $isModal) {
                        Choice()
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}) {
                        
                        Image("profile")
                            .renderingMode(.original)
                    }
                }
                .padding([.horizontal,.bottom])
                .padding(.top,10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack{
                        
                        HStack(spacing: 15){
                            
                            HStack(spacing: 10){
                                
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField("Search Recipe", text: $search)
                            }
                            .padding()
                            .background(Color.black.opacity(0.06))
                            .cornerRadius(15)
                            
                            Button(action: {}) {
                                
                                Image("filter")
                                    .renderingMode(.original)
                                    .padding()
                                    .background(Color("yellow").opacity(0.2))
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack{
                            
                            Text("Top Recipes")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Spacer(minLength: 0)
                        }
                        .padding()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 15){
                                
                                ForEach(recipes,id: \.title){recipe in
                                    
                                    RecipeCard(recipe: recipe)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 20){
                                
                                ForEach(categories,id: \.self){title in
                                    
                                    CategoryCard(title: title)
                                }
                            }
                            .padding()
                        }
                    }
                }
                
            }
            .background(Color.blue.opacity(0.05).ignoresSafeArea(.all, edges: .all))
            .ignoresSafeArea(.all, edges: .bottom)
        }
}

struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        Favorites()
    }
}
// RecipeCard


struct RecipeCard: View {
    var recipe : Recipe
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            HStack{
                
                Spacer(minLength: 0)
                
                Image(recipe.image)
            }
            .padding(.bottom)
            
            Text(recipe.title)
                .font(.title2)
                .foregroundColor(.black)
            
            HStack(spacing: 12){
                
                Label(title: {
                    Text(recipe.rating)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                }) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(Color("orange"))
                }
                .padding(.vertical,5)
                .padding(.horizontal,10)
                .background(recipe.color.opacity(0.4))
                .cornerRadius(5)
                
                Text(recipe.type)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical,5)
                    .padding(.horizontal,10)
                    .background(recipe.color.opacity(0.4))
                    .cornerRadius(5)
            }
            
            Text(recipe.detail)
                .foregroundColor(.gray)
                .lineLimit(3)
            
            HStack(spacing: 0){
                
                ForEach(1...4,id: \.self){i in
                    
                    Image("p\(i)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                    // Overlay Effect
                        .offset(x: -CGFloat(i) * 8)
                }
                
                Text("25+ Likes")
                    .font(.caption)
                    .foregroundColor(.gray)
                    // Moving Text And Giving Space...
                    .padding(.leading, -(4) * 6)
            }
            .padding(.bottom)
            
            HStack{
                
                Spacer(minLength: 0)
                
                Button(action: {}) {
                    
                    Label(title: {
                        Text("Save")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black)
                        
                    }) {
                        Image(systemName: "suit.heart.fill")
                            .font(.body)
                            .foregroundColor(Color("orange"))
                    }
                    .padding(.vertical,8)
                    .padding(.horizontal,10)
                    .background(Color.white)
                    .clipShape(Capsule())
                }
            }
            
        }
        .padding(.horizontal)
        // Max Width....
        .frame(width: UIScreen.main.bounds.width / 2)
        .background(
            recipe.color.opacity(0.2)
                .cornerRadius(25)
                .padding(.top,55)
                .padding(.bottom,15)
        )
    }
}

// CategoryCard


struct CategoryCard: View {
    var title : String
    var body: some View {
        
        VStack(spacing: 20){
            
            Image(title)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
            
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(Color("orange"))
        }
        .padding(.vertical)
        .padding(.horizontal,10)
        .background(Color("yellow").opacity(0.2))
        .clipShape(Capsule())
    }
}




// Custom Corner


struct CustomCornerFavourites : Shape {
    var corners : UIRectCorner
    var size : CGFloat
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: size, height: size))
        
        return Path(path.cgPath)
    }
}

// RecipeData

import SwiftUI

struct Recipe {
    var image: String
    var title : String
    var detail : String
    var rating : String
    var type: String
    var color: Color
}

var recipes = [

    Recipe(image: "r1", title: "Mexican Egg Mix", detail: "A gentle combination of carefully chosen veggies with a Mexican taste.", rating: "4.5", type: "easy",color: Color("blue")),
    Recipe(image: "r2", title: "Italian Baked Dish", detail: "Italian based spicy and green beans baked together with cheeze", rating: "4.8", type: "hard",color: Color("yellow"))
]

var categories = ["Fruits","Meats","Sushi","Fries"]

   
