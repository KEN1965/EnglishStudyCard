//
//  ContentView.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
//

iimport SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \.tag) private var phrases: [PhraseEntity]
    
    @State private var selectedTag: String? = nil
    @State private var selectedCategory: String? = nil
    @State private var isTrainingActive = false
    private let feedback = UIImpactFeedbackGenerator(style: .soft)
    
    private var tags: [String] {
        Array(Set(phrases.compactMap { $0.tag })).sorted()
    }
    private var categories: [String] {
        // 文型選択に応じてカテゴリ候補を絞る
        let filtered = phrases.filter { p in
            if let t = selectedTag { return p.tag == t } else { return true }
        }
        return Array(Set(filtered.compactMap { $0.category })).sorted()
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text("英語スピーキング練習")
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                    Text("文型とカテゴリを選んで、ふわっと練習を始めよう")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)
                
                Group {
                    // ① 文型
                    VStack(spacing: 10) {
                        Text("文型を選択").font(.headline).fontDesign(.rounded)
                        Picker("文型", selection: $selectedTag) {
                            Text("すべて").tag(String?.none)
                            ForEach(tags, id: \.self) { tag in
                                Text(tag).tag(Optional(tag))
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 110)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    }
                    
                    // ② カテゴリ
                    VStack(spacing: 10) {
                        Text("カテゴリを選択").font(.headline).fontDesign(.rounded)
                        Picker("カテゴリ", selection: $selectedCategory) {
                            Text("すべて").tag(String?.none)
                            ForEach(categories, id: \.self) { cat in
                                Text(cat).tag(Optional(cat))
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 110)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal)
                
                Button {
                    feedback.impactOccurred()
                    isTrainingActive = true
                } label: {
                    Label("トレーニングを始める", systemImage: "play.circle.fill")
                        .font(.title2.bold())
                        .fontDesign(.rounded)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue, in: RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.white)
                        .shadow(radius: 6, y: 3)
                }
                .padding(.horizontal, 40)
                .disabled(phrases.isEmpty)
                
                Spacer(minLength: 0)
                
                NavigationLink {
                    ResultView()
                } label: {
                    Label("学習結果をみる", systemImage: "chart.bar.fill")
                        .fontDesign(.rounded)
                        .padding(.bottom, 24)
                }
            }
            .navigationDestination(isPresented: $isTrainingActive) {
                TrainingView(selectedTag: selectedTag, selectedCategory: selectedCategory)
            }
            .padding(.bottom, 8)
        }
    }
}
