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
  private let generator: AnswerGeneratorProtocol

  init(records: [Int] = [],  generator: AnswerGeneratorProtocol = RandomAnswerGenerator()) {
    self.records = records
    self.generator = generator
  }


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
        await saveRecord(attempts)
      case 2:
        #logDebug("\(choice) // 2번 게임 기록 보기 입력")
        await showRecords()
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
    let answer =  generator.make(digits: digits)
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

  // MARK: - 기록 저장/출력
  private func saveRecord(_ attempts: Int) async {
    records.append(attempts)
  }

  private func showRecords()  async {
    #logDebug("< 게임 기록 보기 >")
    if records.isEmpty {
      #logDebug("완료된 게임 기록이 없습니다.")
      return
    }

    for (index, value) in records.enumerated() {
      #logDebug("\(index + 1)번째 게임 : 시도 횟수 - \(value)")
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
    let strike = zip(answer, guess).filter { $0 == $1 }.count
    let ball = Set(answer).intersection(guess).count - strike
    if strike == answer.count { return .correct }
    if strike == 0 && ball == 0 { return .nothing }
    return .strikeAndBall(strike: strike, ball: ball)
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
