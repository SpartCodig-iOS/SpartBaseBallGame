//
//  BaseBallGame.swift
//  SpartBaseBallGame
//
//  Created by Wonji Suh  on 8/27/25.
//

import Foundation
import LogMacro

actor BaseBallGame {
  private let digits = 3

  // MARK: - 게임시작
  func start() async {
    #logInfo("게임 시작 — 규칙: 1~9, 서로 다른 \(digits)자리")
    _ = makeAnswer()
  }

  // 매 라운드 정답 생성
  private func makeAnswer() -> [Int] {
    var pool = Array(1...9)
    pool.shuffle()
    #logDebug("랜덤 숫자", Array(pool.prefix(digits)))
    return Array(pool.prefix(digits))
  }



  // MARK: - realine
  func readLineAsync() async -> String? {
    await withCheckedContinuation { continuation in
      Task.detached(priority: .userInitiated) {
        continuation.resume(returning: readLine())
      }
    }
  }
}

