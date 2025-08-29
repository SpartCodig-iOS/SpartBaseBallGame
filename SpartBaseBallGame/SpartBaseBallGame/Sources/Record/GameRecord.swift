//
//  GameRecord.swift
//  SpartBaseBallGame
//
//  Created by Wonji Suh  on 8/28/25.
//

import Foundation

// MARK: - 기록 저장/출력
actor GameRecord: Sendable {
  private(set) var items: [Int] = []

   func saveRecord(_ attempts: Int) async {
    items.append(attempts)
  }

  func isEmpty() -> Bool {
    items.isEmpty
  }

  func showRecords(using console: IOProvider) async {
    console.show("< 게임 기록 보기 >")
    if items.isEmpty {
      console.show("완료된 게임 기록이 없습니다.")
      return
    }
    for (idx, tries) in items.enumerated() {
      console.show("\(idx + 1)번째 게임 : 시도 횟수 - \(tries)")
    }
  }
}
