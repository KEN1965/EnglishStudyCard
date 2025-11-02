//
//  ResultView.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
//
import SwiftUI
import SwiftData

struct ResultView: View {
    @Query(sort: \PhraseEntity.lastReviewed, order: .reverse)
    private var phrases: [PhraseEntity]  // ← 型を明示
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 16) {
                Text("学習結果")
                    .font(.largeTitle.bold())
                    .fontDesign(.rounded)
                    .padding(.top)
                
                // 文型別の合計
                let grouped = Dictionary(grouping: phrases) { $0.tag ?? "未分類" }
                List {
                    Section("文型ごとの合計") {
                        ForEach(grouped.keys.sorted(), id: \.self) { key in
                            let items = grouped[key]!
                            let said = items.reduce(0) { $0 + $1.saidCount }
                            let fail = items.reduce(0) { $0 + $1.failCount }
                            HStack {
                                Text(key)
                                Spacer()
                                Text("✅ \(said)  ❌ \(fail)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    Section("直近の練習（最大20件）") {
                        ForEach(phrases.prefix(20)) { p in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(p.ja)
                                    Spacer()
                                    if let d = p.lastReviewed {
                                        Text(d.formatted(date: .abbreviated, time: .shortened))
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Text(p.en)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .padding(.bottom, 8)
        }
    }
}

#Preview {
    ResultView()
        .modelContainer(for: PhraseEntity.self, inMemory: true)
}
