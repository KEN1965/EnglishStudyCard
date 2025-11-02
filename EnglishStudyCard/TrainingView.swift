//
//  TrainingView.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
//
//
//  TrainingView.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
//

import SwiftUI
import AVFoundation

struct TrainingView: View {
    let startPhrases: [PhraseEntity]
    let selectedTag: String?
    let selectedCategory: String?

    @Environment(\.dismiss) private var dismiss
    @State private var index = 0
    @State private var offset: CGSize = .zero
    @State private var results: [String: Bool] = [:]
    @State private var showConfetti = false
    @State private var showEnglish = false

    private let feedback = UIImpactFeedbackGenerator(style: .soft)

    var body: some View {
        ZStack {
            BackgroundView().ignoresSafeArea()

            VStack(spacing: 16) {
                // 🏷️ 文型 × カテゴリ（中央配置）
                HStack(spacing: 8) {
                    if let tag = selectedTag {
                        Text(tag)
                            .font(.headline)
                            .fontDesign(.rounded)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial, in: Capsule())
                    }

                    Text(selectedCategory ?? "すべて")
                        .font(.subheadline)
                        .fontDesign(.rounded)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                }
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 12)

                // ✅ カードを画面のちょうど中央に補正配置
                VStack {
                    if index < startPhrases.count {
                        let p = startPhrases[index]

                        ZStack {
                            VStack(spacing: 36) {
                                // ✅ 日本語
                                Text(p.ja)
                                    .font(.title)
                                    .fontDesign(.rounded)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)

                                // ✅ 英語（タップ後に表示）
                                if showEnglish {
                                    Text(p.en)
                                        .font(.title2)
                                        .fontDesign(.rounded)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .transition(.opacity.combined(with: .scale))
                                        .animation(.spring(), value: showEnglish)
                                        .onTapGesture {
                                            feedback.impactOccurred()
                                            SpeechManager.shared.speak(p.en)
                                        }
                                }

                                // ✅ 英語がまだ出ていないとき
                                if !showEnglish {
                                    Text("👆 タップして英語を表示")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                        .padding(.top, 8)
                                        .transition(.opacity)
                                        .animation(.easeIn, value: showEnglish)
                                        .onTapGesture {
                                            showEnglishTextAndConfetti(for: p.en)
                                        }
                                }

                                // ✅ 言えない／言えた
                                Text("← 言えない　　言えた →")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .padding()
                            }
                            .padding(.vertical, 60)
                            .padding(.horizontal, 24)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(.ultraThinMaterial)
                                    .shadow(radius: 8, y: 4)
                            )
                            .offset(offset)
                            .rotationEffect(.degrees(Double(offset.width / 25)))
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        offset = gesture.translation
                                    }
                                    .onEnded { _ in
                                        handleSwipe(offset: offset)
                                    }
                            )
                            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: offset)

                            // 🌸 花びら
                            if showConfetti {
                                ConfettiView()
                                    .transition(.opacity)
                                    .zIndex(10)
                            }
                        }
                    } else {
                        VStack(spacing: 24) {
                            Text("🎉 トレーニング完了！")
                                .font(.largeTitle.bold())
                            Text("お疲れさまでした。")
                                .foregroundStyle(.secondary)
                            Button("ホームに戻る") {
                                dismiss()
                            }
                            .font(.title2.bold())
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(.blue, in: RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(.white)
                            .shadow(radius: 5, y: 3)
                        }
                        .padding()
                    }
                }
                // 🎯 ここがポイント：カードを中央に補正
                .frame(maxHeight: .infinity, alignment: .center)
                .offset(y: -50) // ← これで「見た目のど真ん中」にくる！
            }
            .padding(.horizontal)
        }
        .navigationTitle("トレーニング")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - 英語表示＋花びら
    private func showEnglishTextAndConfetti(for text: String) {
        if !showEnglish {
            feedback.impactOccurred()
            SpeechManager.shared.speak(text)
            withAnimation(.spring()) {
                showEnglish = true
                showConfetti = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showConfetti = false
            }
        }
    }

    // MARK: - スワイプ処理
    private func handleSwipe(offset: CGSize) {
        let p = startPhrases[index]
        feedback.impactOccurred()

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            if offset.width > 120 {
                results[p.en] = true
                next()
            } else if offset.width < -120 {
                results[p.en] = false
                next()
            } else {
                self.offset = .zero
            }
        }
    }

    private func next() {
        if index + 1 < startPhrases.count {
            offset = .zero
            index += 1
            showEnglish = false
        } else {
            dismiss()
        }
    }
}
