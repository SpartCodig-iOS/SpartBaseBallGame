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
  private var records: [Int] = []

  // MARK: - 게임시작 관련
  func start() async {
    while true {
      showMenu()

      guard let line = await readLineAsync()?.trimmingCharacters(in: .whitespacesAndNewlines),
            let choice = Int(line) else {
        #logDebug("올바르지 않은 입력입니다. 1~3 중 하나를 입력해주세요.")
        continue
      }

      switch choice {
      case 1:
        #logDebug("\(choice) // 1번 게임 시작하기 입력")
        let attempts = await startGame()

      case 2:
        #logDebug("\(choice) // 2번 게임 기록 보기 입력")

      case 3:
        #logDebug("\(choice) // 3번 종료하기 입력")
        #logDebug("프로그램을 종료합니다.")
        return
      default:
        #logDebug("올바르지 않은 입력입니다. 1~3 중 하나를 입력해주세요.")
      }
    }
  }

  private func showMenu() {
    #logDebug("""
        환영합니다! 원하시는 번호를 입력해주세요
        1. 게임 시작하기  2. 게임 기록 보기  3. 종료하기
        """)
  }

  // MARK: - 게임 시작
  func startGame() async -> Int {
    #logDebug("< 게임을 시작합니다 >")
    let answer = makeAnswer()
    #logDebug("정답 생성: \(answer)")

    var attempts = 0

    while true {
      #logDebug("숫자를 입력하세요")
      guard let line = await readLineAsync(),
            let guess = parseGuess(from: line) else {
        #logDebug("올바르지 않은 입력값입니다")
        continue
      }

      attempts += 1
      let result = judge(answer: answer, guess: guess)

      switch result {
      case .correct:
        #logDebug("정답입니다!")
        return attempts

      case .nothing:
        #logDebug("Nothing")

      case .strikeAndBall(let strike, let ball):
        var parts: [String] = []
        if strike > .zero { parts.append("\(strike)스트라이크") }
        if ball > .zero { parts.append("\(ball)볼") }
        #logDebug(parts.joined(separator: " "))
      }
    }
  }

  // MARK: - 입력 파싱
  private func parseGuess(from input: String) -> [Int]? {
    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard trimmed.count == digits,
          trimmed.allSatisfy({ $0.isNumber }),
          trimmed.first != "0" else { return nil }

    let numbers = trimmed.compactMap { Int(String($0)) }
    guard Set(numbers).count == digits else { return nil }
    return numbers
  }

  // MARK: - 판정
  private func judge(answer: [Int], guess: [Int]) -> JudgeResult {
    let strikeCount = zip(answer, guess).filter { $0 == $1 }.count
    let ballCount = guess.filter { answer.contains($0) }.count - strikeCount
    if strikeCount == answer.count { return .correct }
    if strikeCount == .zero && ballCount == .zero { return .nothing }
    return .strikeAndBall(strike: strikeCount, ball: ballCount)
  }

  // MARK: - 정답 생성 (첫 자리 1~9, 이후 0 허용, 중복 금지)
  private func makeAnswer() -> [Int] {
    let firstNumber = Int.random(in: 1...9)
    var pool = Array(0...9).filter { $0 != firstNumber }
    pool.shuffle()
    return [firstNumber] + pool.prefix(digits - 1)
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
