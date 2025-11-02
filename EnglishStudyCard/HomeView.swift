//
//  ContentView.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
//    @Query(sort: [SortDescriptor(\PhraseEntity.tag)]) private var phrases: [PhraseEntity]
//    @Query private var phrases: [PhraseEntity]

    @Query(sort: [SortDescriptor<PhraseEntity>(\.createdAt, order: .forward)])
    private var phrases: [PhraseEntity]

    @State private var selectedTag: String? = nil
    @State private var selectedCategory: String? = nil
    @State private var isTrainingActive = false
    private let feedback = UIImpactFeedbackGenerator(style: .soft)

    // 画面幅に依存しない“統一幅”
    private let contentWidth: CGFloat = min(UIScreen.main.bounds.width - 48, 360)

    private var tags: [String] {
        var ordered = [String]()
        for p in phrases {
            if let tag = p.tag, !ordered.contains(tag) {
                ordered.append(tag)
            }
        }
        return ordered
    }

    private var filteredCategories: [String] {
        var ordered = [String]()
        for p in phrases where (selectedTag == nil || p.tag == selectedTag) {
            if let cat = p.category, !ordered.contains(cat) {
                ordered.append(cat)
            }
        }
        return ordered
    }


    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.mint.opacity(0.25), .pink.opacity(0.25)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer(minLength: UIScreen.main.bounds.height * 0.06) // 上の余白を画面比で可変

                    // タイトル（幅は制限しないが中央揃え）
                    Text("英語スピーキング練習")
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)

                    // 文型/カテゴリ（枠・ピッカーともに contentWidth に厳密固定）
                    VStack(alignment: .leading, spacing: 20) {
                        // 文型
                        VStack(alignment: .leading, spacing: 10) {
                            Text("文型を選択")
                                .font(.headline)
                                .frame(width: contentWidth, alignment: .leading)

                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(.thinMaterial)
                                    .frame(width: contentWidth, height: 120)

                                Picker("文型", selection: $selectedTag) {
                                    Text("すべて").tag(String?.none)
                                    ForEach(tags, id: \.self) { tag in
                                        Text(tag).tag(Optional(tag))
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: contentWidth, height: 120)
                                .onChange(of: selectedCategory) { oldValue, newValue in
                                    let generator = UISelectionFeedbackGenerator()
                                    generator.selectionChanged()
                                }


                            }
                        }

                        // カテゴリ
                        VStack(alignment: .leading, spacing: 10) {
                            Text("カテゴリを選択")
                                .font(.headline)
                                .foregroundStyle(selectedTag == nil ? .gray : .primary)
                                .frame(width: contentWidth, alignment: .leading)

                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(.thinMaterial)
                                    .frame(width: contentWidth, height: 120)

                                Picker("カテゴリ", selection: $selectedCategory) {
                                    if selectedTag == nil {
                                        Text("文型を選んでください").tag(String?.none)
                                    } else {
                                        ForEach(filteredCategories, id: \.self) { cat in
                                            Text(cat).tag(Optional(cat))
                                        }
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: contentWidth, height: 120)
                                .disabled(selectedTag == nil)
                                .onChange(of: selectedCategory) { oldValue, newValue in
                                    let generator = UISelectionFeedbackGenerator()
                                    generator.selectionChanged()
                                }
                                .onChange(of: selectedTag) { oldValue, newValue in
                                    // 文型が変わったらカテゴリをリセット
                                    selectedCategory = nil
                                    print("🔁 文型変更 → カテゴリ初期化（old:\(oldValue ?? "nil") → new:\(newValue ?? "nil")）")

                                    // 新しい文型の「登録順で最初のカテゴリ」を自動選択
                                    if let tag = newValue,
                                       let firstCat = phrases.first(where: { $0.tag == tag })?.category {
                                        selectedCategory = firstCat
                                        print("🟢 自動カテゴリ選択: \(firstCat)")
                                    }
                                }
                            }
                        }
                    }

                    // ガイド文 ↔ ボタン（同じ位置/同じ幅）
                    ZStack {
                        Text("文型とカテゴリを選んで練習を始めよう")
                            .font(.subheadline)
                            .fontDesign(.rounded)
                            .frame(width: contentWidth, height: 80)  // 幅・高さをボタンと一致
                            .opacity(selectedTag == nil ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: selectedTag)
                            .padding(.top, 20)


                        Button {
                            feedback.impactOccurred()
                            
                            if selectedCategory == nil {
                                if let firstCat = filteredCategories.first {
                                    selectedCategory = firstCat
                                    print("🟢 カテゴリ未選択 → 自動選択: \(firstCat)")
                                } else if let firstTag = selectedTag,
                                          let firstCat = phrases.first(where: { $0.tag == firstTag })?.category {
                                    selectedCategory = firstCat
                                    print("🟢 filteredCategories が空なので、登録順カテゴリを使用: \(firstCat)")
                                }
                            }
                            
                            isTrainingActive = true
                        } label: {
                            Label("トレーニングを始める", systemImage: "play.circle.fill")
                                .font(.title2.bold())
                                .fontDesign(.rounded)
                                .frame(width: contentWidth, height: 80) // ← 厳密固定
                                .background(.blue, in: RoundedRectangle(cornerRadius: 16))
                                .foregroundStyle(.white)
                                .shadow(radius: 6, y: 3)
                                .padding(.top, 20)
                        }
                        // 余計な .padding() は付けない（背景サイズが広がる原因）
                        .opacity(selectedTag == nil ? 0 : 1)
                        .animation(.easeInOut(duration: 0.5), value: selectedTag)
                        .disabled(selectedTag == nil)
                    }

                    Spacer(minLength: UIScreen.main.bounds.height * 0.05) // 下の余白も可変

                }
                .navigationDestination(isPresented: $isTrainingActive) {
                    // ✅ 文型だけ選択でカテゴリ未選択なら、登録順の「最初のカテゴリ」を自動採用
                    let activeCategory: String? = {
                        if let c = selectedCategory { return c }
                        if let t = selectedTag {
                            // 登録順（createdAt順でフェッチ済み）で最初に見つかったカテゴリ
                            return phrases.first(where: { $0.tag == t })?.category
                        }
                        return nil
                    }()

                    // フィルタ
                    let filteredPhrases = phrases.filter { phrase in
                        (selectedTag == nil || phrase.tag == selectedTag) &&
                        (activeCategory == nil || phrase.category == activeCategory)
                    }

                    TrainingView(
                        startPhrases: filteredPhrases,
                        selectedTag: selectedTag,
                        selectedCategory: activeCategory
                    )
                }

                // 右下の「？」ボタン
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink {
                            AboutView()
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 26))
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(.blue, in: Circle())
                                .shadow(radius: 6, y: 3)
                        }
                        .padding(.bottom, 25)
                        .padding(.trailing, 25)
                    }
                }
            }
        }
    }
}
