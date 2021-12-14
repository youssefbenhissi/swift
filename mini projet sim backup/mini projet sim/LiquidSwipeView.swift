//  LiquidSwipeView.swift
//  LiquidMotionSwipe
//
//  Created by Ashish Singh on 10/10/20.
//

import SwiftUI

struct LiquidSwipeView: View {
   
    @State var rightData = SliderData(side: .right)
    
    @State var pageIndex = 0
    @State var topSlider = SliderDirection.right
    @State var sliderOffset: CGFloat = 0
    @State var isModal: Bool = false
    @State var showLoginView: Bool = false
    @State var selected = "Home"
    var body: some View {
        ZStack {
            
            content()
            

        }
        .edgesIgnoringSafeArea(.all)
    }
    
    
    func content() -> some View {
        return  ZStack {
            if pageIndex == 0 {
                slider(data: $rightData)
            }
            if pageIndex == 1 {
                slider(data: $rightData)
            }
            
            Rectangle().foregroundColor(Config.colors[pageIndex])
            VStack{
                
                Image(uiImage: UIImage(named: Config.imagesToBeShown[pageIndex])!)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(10)
                Text(Config.titleToBeShown[pageIndex])
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(50)
                Text(Config.paragraphToBeShown[pageIndex])
                   
                          .padding(.all, 5)
                          .font(Font.system(size: 30, design: .default))
                          .multilineTextAlignment(.center)
                
                
                    
                        
                    Button(action: {
                        self.isModal = true
                            }) {
                                Image(systemName: "arrow.right")
                                    .padding(20)
                                    .background(Color(.white))
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            
                            }.sheet(isPresented: $isModal) {
                                Choice()
                            }
                    
                
            }
            

        }
    }
    
    private func index(of data: SliderData) -> Int {
        let last = Config.colors.count - 1
        if data.side == .left {
            return pageIndex == 0 ? last : pageIndex - 1
            
        } else {
            return pageIndex == last ? 0 : pageIndex + 1
        }
    }
    
    private func swipe(data: Binding<SliderData>) {
        withAnimation() {
            data.wrappedValue = data.wrappedValue.final()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.pageIndex = self.index(of: data.wrappedValue)
            self.rightData = self.rightData.initial()
            
            self.sliderOffset = 100
            withAnimation(.spring(dampingFraction: 0.5)) {
                self.sliderOffset = 0
            }
        }
    }
    
    func wave(data: Binding<SliderData>) -> some View {
        let gesture = DragGesture().onChanged {
            self.topSlider = data.wrappedValue.side
            data.wrappedValue = data.wrappedValue.drag(value: $0)
        }
        .onEnded {
            if data.wrappedValue.isCancelled(value: $0) {
                withAnimation(.spring(dampingFraction: 0.5)) {
                    data.wrappedValue = data.wrappedValue.initial()
                }
            } else {
                self.swipe(data: data)
            }
        }
        .simultaneously(with: TapGesture().onEnded {
            self.topSlider = data.wrappedValue.side
            self.swipe(data: data)
        })
        return WaveView(data: data.wrappedValue).gesture(gesture)
            .foregroundColor(Config.colors[index(of: data.wrappedValue)])
    }
    
    private func circle(radius: Double) -> Path {
        
        return Path { path in
            path.addEllipse(in: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2))
        }
    }
    
    private func polyLine(_ values: Double...) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: values[0], y: values[1]))
            for i in stride(from: 2, to: values.count, by: 2) {
                path.addLine(to: CGPoint(x: values[i], y: values[i + 1]))
            }
        }
    }
    func  button(data: SliderData) -> some View {
        let arrowWidth = (data.side == .left ? 1 : -1) * Config.arrowWidth / 2
        let arrowHeight = Config.arrowHeight / 2
        
        return ZStack {
            circle(radius: Config.buttonRadius).stroke().opacity(0.2)
            polyLine(-arrowWidth, -arrowHeight, arrowWidth, 0, -arrowWidth, arrowHeight).stroke(Color.black, lineWidth: 2)
        }
        .offset(data.buttonOffset)
        .opacity(data.buttonOpacity)
    }
    
    func slider(data: Binding<SliderData>) -> some View {
        let value = data.wrappedValue
        
        return ZStack {
            wave(data: data)
            button(data: value)
        }
        .zIndex(topSlider == value.side ? 1 : 0)
        .offset(x: value.side == .left ? -sliderOffset : sliderOffset)
    }
    
    
}

struct LiquidSwipeView_Previews: PreviewProvider {
    static var previews: some View {
        LiquidSwipeView()
    }
}
