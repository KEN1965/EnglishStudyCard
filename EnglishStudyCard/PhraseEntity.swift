//
//  PhraseEntity.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
//
import Foundation
import SwiftData

@Model
class PhraseEntity {
    var id: UUID
    var en: String
    var ja: String
    var tag: String?
    var category: String?

    var saidCount: Int
    var failCount: Int
    var lastReviewed: Date?
    var nextDueDate: Date?

    // ✅ 追加：登録順のためのタイムスタンプ
    var createdAt: Date

    init(
        id: UUID = UUID(),
        en: String,
        ja: String,
        tag: String? = nil,
        category: String? = nil,
        createdAt: Date = Date()   // ← 追加（デフォルトは現在時刻）
    ) {
        self.id = id
        self.en = en
        self.ja = ja
        self.tag = tag
        self.category = category
        self.saidCount = 0
        self.failCount = 0
        self.lastReviewed = nil
        self.nextDueDate = nil
        self.createdAt = createdAt
    }
}
