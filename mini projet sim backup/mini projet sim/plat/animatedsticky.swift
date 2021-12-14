//
//  animatedsticky.swift
//  mini projet sim
//
//  Created by youssef benhissi on 10/01/2021.
//

import SwiftUI

struct animatedsticky: View {
    var body: some View {
        HomeSticky()
    }
}

struct animatedsticky_Previews: PreviewProvider {
    static var previews: some View {
        animatedsticky()
    }
}

// Home

import SwiftUI

struct HomeSticky: View {
    @StateObject var homeData = HomeViewModel()
    // For Dark Mode Adoption....
    @Environment(\.colorScheme) var scheme
    var body: some View {
        
        ScrollView{
            
            // Since Were Pinning Header View....
            LazyVStack(alignment: .leading, spacing: 15, pinnedViews: [.sectionHeaders], content: {
                
                // Parallax Header....
                
                GeometryReader{reader -> AnyView in
                    
                    let offset = reader.frame(in: .global).minY
                    
                    if -offset >= 0{
                        DispatchQueue.main.async {
                            self.homeData.offset = -offset
                        }
                    }
                    
                    return AnyView(
                    
                        Image("foodsticky")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: 250 + (offset > 0 ? offset : 0))
                            .cornerRadius(2)
                            .offset(y: (offset > 0 ? -offset : 0))
                            .overlay(
                            
                                HStack{
                                    
                                    Button(action: {}, label: {
                                        Image(systemName: "arrow.left")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                    })
                                    
                                    Spacer()
                                    
                                    Button(action: {}, label: {
                                        Image(systemName: "suit.heart.fill")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                    })
                                }
                                .padding(),
                                alignment: .top
                            )
                    )
                }
                .frame(height: 250)
                
                // Cards......
                
                Section(header: HeaderView()) {

                    // Tabs With Content.....
                    
                    ForEach(tabsItems){tab in
                        
                        VStack(alignment: .leading, spacing: 15, content: {
                            
                            Text(tab.tab)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom)
                                .padding(.leading)
                            
                            ForEach(tab.foods){food in
                                
                                CardViewSticky(food: food)
                            }
                            
                            Divider()
                                .padding(.top)
                        })
                        .tag(tab.tab)
                        .overlay(
                        
                            GeometryReader{reader -> Text in
                                
                                // Calculating Whicj tab....
                                
                                let offset = reader.frame(in: .global).minY
                                
                                // Top Area Plus Header Size 100
                                let height = UIApplication.shared.windows.first!.safeAreaInsets.top + 100
                                
                                if offset < height && offset > 50 && homeData.selectedtab != tab.tab{
                                    DispatchQueue.main.async {
                                        self.homeData.selectedtab = tab.tab
                                    }
                                }
                                
                                return Text("")
                            }
                        )
                    }
                }
            })
        }
        .overlay(
        
            // Only Safe Area....
            (scheme == .dark ? Color.black : Color.white)
                .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                .ignoresSafeArea(.all, edges: .top)
                .opacity(homeData.offset > 250 ? 1 : 0)
            ,alignment: .top
        )
        // Used It Environment Object For Accessing All SUb Objects....
        .environmentObject(homeData)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// CardView

import SwiftUI

struct CardViewSticky: View {
    var food: Food
    var body: some View {
        
        HStack{
            
            VStack(alignment: .leading, spacing: 10, content: {
                
                Text(food.title)
                    .fontWeight(.bold)
                
                Text(food.description)
                    .font(.caption)
                    .lineLimit(3)
                
                Text(food.price)
                    .fontWeight(.bold)
            })
            
            Spacer(minLength: 10)
            
            Image(food.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130, height: 130)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// Header View

import SwiftUI

struct HeaderView: View {
    
    @EnvironmentObject var homeData : HomeViewModel
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0){
            
            HStack(spacing: 0){
                
                // BackButton...
                Button(action: {}, label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: getSize(), height: getSize())
                        .foregroundColor(.primary)
                })
                
                Text("Kavsoft Bakery")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            ZStack{
                
                VStack(alignment: .leading, spacing: 10, content: {
                    
                    Text("Asiatisch . Koreanisch . Japnisch")
                        .font(.caption)
                    
                    HStack(spacing: 8){
                        
                        Image(systemName: "clock")
                            .font(.caption)
                        
                        Text("30-40 Min")
                            .font(.caption)
                        
                        Text("4.3")
                            .font(.caption)
                        
                        Image(systemName: "star.fill")
                            .font(.caption)
                        
                        Text("$6.40 Fee")
                            .font(.caption)
                            .padding(.leading,10)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                })
                .opacity(homeData.offset > 200 ? 1 - Double((homeData.offset - 200) / 50) : 1)
                
                // Custom ScrollView....
                
                // For Automatic Scrolling...
                
                ScrollViewReader {reader in
                    
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        
                        HStack(spacing: 0){
                            
                            ForEach(tabsItems){tab in
                                
                                Text(tab.tab)
                                    .font(.caption)
                                    .padding(.vertical,10)
                                    .padding(.horizontal)
                                    .background(Color.primary.opacity(homeData.selectedtab == tab.tab ? 1 : 0))
                                    .clipShape(Capsule())
                                    .foregroundColor(homeData.selectedtab == tab.tab ? scheme == .dark ? .black : .white : .primary)
                                    .id(tab.tab)
                            }
                            .onChange(of: homeData.selectedtab, perform: { value in
                                
                                // When Scrolling Very Fastly
                                // Animation Is Having Some Problem In Scroll Reader...
                                // May Be It's A Bug....
                                // Comment withAnimation Clouse in That Case....
                                
                                withAnimation(.easeInOut){
                                    reader.scrollTo(homeData.selectedtab,anchor: .leading)
                                }
                            })
                        }
                    })
                    
                    // Visible Only When Scrolls Up...
                    .opacity(homeData.offset > 200 ? Double((homeData.offset - 200) / 50) : 0)
                }
            }
            // Default Frame = 60...
            // Top Fram = 40
            // So Total = 100
            .frame(height: 60)
    
            if homeData.offset > 250{
                Divider()
            }
        }
        .padding(.horizontal)
        .frame(height: 100)
        .background(scheme == .dark ? Color.black : Color.white)
    }
    
    // Getting Size Of Button And Doing ANimation...
    func getSize()->CGFloat{
        
        if homeData.offset > 200{
            let progress = (homeData.offset - 200) / 50
            
            if progress <= 1.0{
                return progress * 40
            }
            else{
                return 40
            }
        }
        else{
            return 0
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// Food Model

import SwiftUI

// Food Model And Sample Food items....

struct Food: Identifiable {
    var id = UUID().uuidString
    var title: String
    var description: String
    var price: String
    var image: String
}


var foods = [

    Food(title: "Choclate Cake", description: "Chocolate cake or chocolate gâteau is a cake flavored with melted chocolate, cocoa powder, or both", price: "$19",image: "choclatessticky"),
    Food(title: "Cookies", description: "A biscuit is a flour-based baked food product. Outside North America the biscuit is typically hard, flat, and unleavened", price: "$10",image: "cookiessticky"),
    Food(title: "Sandwich", description: "Trim the bread from all sides and apply butter on one bread, then apply the green chutney all over.", price: "$9",image: "sandwichsticky"),
    Food(title: "French Fries", description: "French fries, or simply fries, chips, finger chips, or French-fried potatoes, are batonnet or allumette-cut deep-fried potatoes.", price: "$15",image: "friessticky"),
    Food(title: "Pizza", description: "Pizza is a savory dish of Italian origin consisting of a usually round, flattened base of leavened wheat-based dough topped", price: "$39",image: "pizzasticky"),
]

// Tab Model

import SwiftUI

// Tab Model With Tab Items....

struct Tab: Identifiable {
    
    var id = UUID().uuidString
    var tab : String
    var foods: [Food]
}
var tabsItems = [

    Tab(tab: "Order Again", foods: foods.shuffled()),
    Tab(tab: "Picked For You", foods: foods.shuffled()),
    Tab(tab: "Starters", foods: foods.shuffled()),
    Tab(tab: "Gimpub Sushi", foods: foods.shuffled()),
]

// HomeViewModel

import SwiftUI

class HomeViewModel: ObservableObject{
    @Published var offset: CGFloat = 0
    
    // Selected Tab....
    @Published var selectedtab = tabsItems.first!.tab
}
