//
//  Visuals.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
//
import SwiftUI

// 柔らかいパステル背景
struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [Color.mint.opacity(0.4),
                     Color.pink.opacity(0.3),
                     Color.blue.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .blur(radius: 60)
    }
}

struct ConfettiView: View {
    @State private var animate = false
    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { _ in
                Circle()
                    .fill(randomColor())
                    .frame(width: 6, height: 6)
                    .offset(x: CGFloat.random(in: -60...60),
                            y: animate ? CGFloat.random(in: (-200)...(-80)) : 0)
                    .opacity(animate ? 0 : 1)
                    .animation(.easeOut(duration: Double.random(in: 1.2...2.0)),
                               value: animate)
            }
        }
        .onAppear { animate = true }
    }
    private func randomColor() -> Color {
        [.mint, .pink, .blue, .orange, .yellow].randomElement() ?? .mint
    }
}
