//
//  EnglishStudyCardApp.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
//

//
//  EnglishStudyCardApp.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

@main
struct EnglishCardApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([PhraseEntity.self])
        let config = ModelConfiguration()
        return try! ModelContainer(for: schema, configurations: config)
    }()

    var body: some Scene {
        WindowGroup {
            SeederWrapperView()
                .modelContainer(sharedModelContainer)
        }
    }
}

struct SeederWrapperView: View {
    @Environment(\.modelContext) private var context
    @Query private var phrases: [PhraseEntity]
    @State private var didSeed = false

    var body: some View {
        HomeView()
            .onAppear {
                if !didSeed && phrases.isEmpty {
                    seedIfNeeded()
                    didSeed = true
                }
            }
        }
    

    private func seedIfNeeded() {
        // ① 既存データを全削除（毎回クリーンにする）
        do {
            let all = try context.fetch(FetchDescriptor<PhraseEntity>())
            all.forEach { context.delete($0) }
            try context.save()
            print("🧹 既存データ削除: \(all.count) 件")
        } catch {
            print("❌ 既存データ削除エラー: \(error)")
        }

        // ② 追加したダミーデータを投入（あなたの PhraseSeeder をそのまま使用）
        PhraseSeeder.seed(into: context)
        print("✅ 再シード完了")

        let sampleData: [PhraseEntity] = [
            PhraseEntity(en: "I can swim.", ja: "私は泳げます。", tag: "I can〜", category: "日常"),
            PhraseEntity(en: "Can I open the window?", ja: "窓を開けてもいいですか？", tag: "Can I〜", category: "日常"),
            PhraseEntity(en: "Would you like some coffee?", ja: "コーヒーはいかがですか？", tag: "Would you like〜", category: "日常"),
            PhraseEntity(en: "I have to work tomorrow.", ja: "明日仕事をしなければなりません。", tag: "I have to〜", category: "仕事"),
            PhraseEntity(en: "I want to travel to Japan.", ja: "日本を旅行したいです。", tag: "I want to〜", category: "趣味")
        ]
        for phrase in sampleData { context.insert(phrase) }
        try? context.save()
        print("✅ 初期データ登録完了：\(sampleData.count)件")
    }
}
