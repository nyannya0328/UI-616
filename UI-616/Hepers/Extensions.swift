//
//  Extensions.swift
//  UI-616
//
//  Created by nyannyan0328 on 2022/07/19.
//

import SwiftUI

extension View{
    @ViewBuilder
    func addSpotLight(_ id : Int ,shpe : SpotLightShape = .rectangle,roudedRaidius : CGFloat = 0, text : String = "")->some View{
        
        self
            .anchorPreference(key : BoudsKey.self, value: .bounds) {  [id : BoudsProperties(shape: shpe, anchor: $0,text: text)]
                
            }
        
        
    }
    @ViewBuilder
    func addSpotlightOverlay(show : Binding<Bool>,curretSpot : Binding<Int>)->some View{
        
        
        self
            .overlayPreferenceValue(BoudsKey.self) { value in
                
                
                GeometryReader{proxy in
                    
                    if let prefrence = value.first(where: { item in
                        
                        item.key == curretSpot.wrappedValue
                    }){
                        let screenSize = proxy.size
                        
                        let anchor = proxy[prefrence.value.anchor]
                        
                        
                        SpotLightHelper(scrrenSize: screenSize, rect: anchor, show: show, currentSpot: curretSpot, properties: prefrence.value) {
                            
                            
                            if curretSpot.wrappedValue <= (value.count){
                                
                                
                                curretSpot.wrappedValue += 1
                            }
                            else{
                                
                                show.wrappedValue = true
                            }
                            
                            
                        }
                    }
                    
                }
            }
            .ignoresSafeArea()
            .animation(.easeInOut, value: show.wrappedValue)
            .animation(.easeInOut, value: curretSpot.wrappedValue)
           .opacity(show.wrappedValue ? 1 : 0)
        
        
    }
    
    @ViewBuilder
    func SpotLightHelper(scrrenSize : CGSize,rect : CGRect,show : Binding<Bool>,currentSpot : Binding<Int>,properties : BoudsProperties, onTap :@escaping()->())->some View{
        
        
        
        Rectangle()
            .fill(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
       
            .overlay(alignment:.topLeading){
                
                
                Text(properties.text)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                    .opacity(0)
                    .overlay {
                        
                    
                        GeometryReader{proxy in
                            
                            let textSize = proxy.size
                           
                           Text(properties.text)
                               .font(.title2.weight(.bold))
                               .foregroundColor(.white)
                               .offset(x:rect.minX + textSize.width > (scrrenSize.width - 15) ? -((rect.minX + textSize.width) - (scrrenSize.width - 15)) : 0)
                               .offset(y:(rect.maxY + textSize.height) > (scrrenSize.height - 50) ? -(textSize.height + (rect.maxY - rect.minY) + 30) : 30)
                           
                        }
                        
                        
                    }
                    .offset(x:rect.minX,y:rect.maxY)
                
                
               
             
               
                
               
                
            }
          
            .mask {
                Rectangle()
                    .overlay(alignment:.topLeading) {
                        
                        
                        let radius = properties.shape == .circle ? (rect.width / 2) : (properties.shape == .rectangle ? 0 : properties.radius)
                        
                        
                        RoundedRectangle(cornerRadius: radius,style: .continuous)
                            .frame(width:rect.width ,height:rect.height)
                            .offset(x:rect.minX,y:rect.minY)
                            .blendMode(.destinationOut)
                    }
                
            }
            .onTapGesture {
                onTap()
            }
           
        
        
    }
    
    
}



enum SpotLightShape{
    
    case circle
    case rectangle
    case rouded
}


struct BoudsKey : PreferenceKey{
    
    static var defaultValue: [Int : BoudsProperties] = [:]
    
    static func reduce(value: inout [Int : BoudsProperties], nextValue: () -> [Int : BoudsProperties]) {
        value.merge(nextValue()){$1}
    }
    
}

struct BoudsProperties{
    var shape : SpotLightShape
    var anchor : Anchor<CGRect>
    var text : String = ""
    var radius : CGFloat = 0
}


struct Extensions_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
