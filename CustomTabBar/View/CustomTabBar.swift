//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Eduardo Martin Lorenzo on 17/6/22.
//

import SwiftUI

struct CustomTabBar: View {
    @StateObject var tabData = TabViewModel()
    
    @Namespace var animation
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: $tabData.currentTab) {
            HomeView()
                .environmentObject(tabData)
                .tag("Home")
            
            Text("Purchased")
                .tag("Purchased") // El tag es lo que lo vincula con el title del TabBarButton, que indirectamente va vinculado con el selection: $tabData.currentTab
            
            Text("Settings")
                .tag("Settings")
        }
        .overlay(
            HStack {
                TabBarButton(title: "Home", image: "house", animation: animation)
                
                TabBarButton(title: "Purchased", image: "purchased.circle", animation: animation)
                
                TabBarButton(title: "Settings", image: "gear.circle", animation: animation)
            }
                .environmentObject(tabData)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(.thinMaterial, in: Capsule())
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .shadow(color: .black.opacity(0.09), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.09), radius: 5, x: -5, y: 0)
            , alignment: .bottom
        )
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar()
    }
}

struct TabBarButton: View {
    var title: String
    var image: String
    var animation: Namespace.ID
    
    @EnvironmentObject var tabData: TabViewModel
    
    var body: some View {
        Button {
            withAnimation {
                tabData.currentTab = title
            }
        } label: {
            VStack {
                Image(systemName: image)
                    .font(.title2)
                    .frame(height: 18)
                
                Text(title)
                    .font(.caption.bold())
            }
            .foregroundColor(tabData.currentTab == title ? .purple : .gray)
            .frame(maxWidth: .infinity)
            .overlay (
                ZStack {
                    if tabData.currentTab == title {
                        TabIndicator()
                            .fill(.linearGradient(
                                .init(colors: [
                                    .purple.opacity(0.2),
                                    .purple.opacity(0.1),
                                    .clear
                                ]),
                                startPoint: .top,
                                endPoint: .bottom))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                            .padding(.top, -10)
                            .padding(.horizontal, 8)
                    }
                }
            )
        }

    }
}

struct TabIndicator: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width - 10, y: rect.height))
            path.addLine(to: CGPoint(x: 10, y: rect.height ))
        }
    }
}
