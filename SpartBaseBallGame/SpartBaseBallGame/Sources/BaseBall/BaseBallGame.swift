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

  // MARK: - 게임 시작
  func start() async {
    #logDebug("< 게임을 시작합니다 >")
    let answer = makeAnswer()
    #logDebug("정답 생성: \(answer)")

    while true {
      #logDebug("숫자를 입력하세요")
      guard let line = await readLineAsync(),
            let guess = parseGuess(from: line) else {
        #logDebug("올바르지 않은 입력값입니다")
        continue
      }

      let result = judge(answer: answer, guess: guess)

      switch result {
        case .correct:
          #logDebug("정답입니다!")
          return

        case .nothing:
          #logDebug("Nothing")

        case .strikeAndBall(let strike, let ball):
          var parts: [String] = []
          if strike > 0 { parts.append("\(strike)스트라이크") }
          if ball > 0 { parts.append("\(ball)볼") }
          #logDebug(parts.joined(separator: " "))
      }
    }
  }

  // MARK: - 입력 파싱
  private func parseGuess(from input: String) -> [Int]? {
    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard trimmed.count == digits,
          trimmed.allSatisfy({ $0.isNumber }),
          !trimmed.contains("0") else { return nil }
    let numbers = trimmed.compactMap { Int(String($0)) }
    guard Set(numbers).count == digits else { return nil }
    return numbers
  }

  // MARK: - 판정
  private func judge(answer: [Int], guess: [Int]) -> JudgeResult {
    let strikeCount = zip(answer, guess).filter { $0 == $1 }.count
    let ballCount = guess.filter { answer.contains($0) }.count - strikeCount
    if strikeCount == answer.count { return .correct }
    if strikeCount == 0 && ballCount == 0 { return .nothing }
    return .strikeAndBall(strike: strikeCount, ball: ballCount)
  }

  // MARK: - 정답 생성
  private func makeAnswer() -> [Int] {
    var pool = Array(1...9)
    pool.shuffle()
    return Array(pool.prefix(digits))
  }

  // MARK: - readLine 비동기 래핑
  func readLineAsync() async -> String? {
    await withCheckedContinuation { continuation in
      Task.detached(priority: .userInitiated) {
        continuation.resume(returning: readLine())
      }
    }
  }
}

