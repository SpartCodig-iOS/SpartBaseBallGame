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
    let answer = makeAnswer()
    #logInfo("게임 시작 — 규칙: 1~9, 서로 다른 \(digits)자리")

    while true {
      guard let guess = await readGuessAsync() else {
        #logError("잘못된 입력 — 예: 123 (1~9, 중복 없음)")
        continue
      }

      let (strikes, balls) = judge(answer: answer, guess: guess)
      let guessString = guess.map(String.init).joined()

      #logInfo("\(strikes)S \(balls)B — 입력: \(guessString)")
      if strikes == digits {
        #logInfo("정답! \(guessString)")
        break
      }
    }
  }

  // 매 라운드 정답 생성
  private func makeAnswer() -> [Int] {
    var pool = Array(1...9)
    pool.shuffle()
    return Array(pool.prefix(digits))
  }

  private func readGuessAsync() async -> [Int]? {
    #logDebug("프롬프트: 숫자 \(digits)개 입력 대기")
    guard let raw = await readLineAsync() else { return nil }
    let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)

    guard trimmed.count == digits else {
      let relation = trimmed.count < digits ? "작음" : "큼"
      #logError("길이 불일치: 입력 \(trimmed.count)자리 → \(relation), 정답은 \(digits)자리")
      return nil
    }
    guard Set(trimmed).count == digits else {
      #logError("중복 숫자 포함 — \(trimmed)")
      return nil
    }
    guard trimmed.allSatisfy({ ("1"..."9").contains(String($0)) }) else {
      #logError("허용 범위 외 문자 포함 — \(trimmed)")
      return nil
    }

    let numbers = trimmed.compactMap { Int(String($0)) }
    #logDebug("입력 성공: \(numbers)")
    return numbers
  }

  // MARK: - 판정
  private func judge(answer: [Int], guess: [Int]) -> (strikeCount: Int, ballCount: Int) {
    let strikeCount = zip(answer, guess).filter { $0 == $1 }.count
    let ballCount = guess.filter { answer.contains($0) }.count - strikeCount
    return (strikeCount, ballCount)
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

