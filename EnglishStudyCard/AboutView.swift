//
//  AboutView.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
//
import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("📘 このアプリの使い方")
                    .font(.largeTitle.bold())
                    .fontDesign(.rounded)
                    .padding(.top, 40)

                Group {
                    Text("1️⃣ 文型を選ぼう").font(.title3.bold())
                    Text("『I can〜』『Can I〜』『Would you like〜』など、練習したい文型を選びます。")

                    Text("2️⃣ カテゴリを選ぼう").font(.title3.bold())
                    Text("日常・仕事・勉強など、シーンに合わせて選びましょう。")

                    Text("3️⃣ トレーニング開始！").font(.title3.bold())
                    Text("日本語を見て頭の中で英語を言ってみよう。タップすると英語が表示・読み上げされます。")

                    Text("4️⃣ スワイプで記録").font(.title3.bold())
                    Text("右へスワイプ → 言えた　／　左へスワイプ → 言えない")
                }

                Divider().padding(.vertical, 16)

                Text("💡 このアプリについて").font(.headline)
                Text("AIと音声を使った英語スピーキング練習アプリです。誰でも手軽に“話す力”を鍛えられます。")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 60)
        }
        .background(
            LinearGradient(colors: [.mint.opacity(0.15), .pink.opacity(0.1)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .navigationTitle("アプリの説明")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { AboutView() }
}

