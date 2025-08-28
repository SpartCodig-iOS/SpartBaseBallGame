//
//  RoundRunner.swift
//  SpartBaseBallGame
//
//  Created by Wonji Suh  on 8/28/25.
//

import Foundation

struct RoundRunner {
  let digits: Int
  let generator: AnswerGeneratorProtocol
  let parser: GuessParser
  let judge: JudgeEngine
  let console: IOProvider

  func run() async -> Int {
    console.show("< 게임을 시작합니다 >")
    let answer = generator.make(digits: digits)
#if DEBUG
    console.show("정답 생성: \(answer)")
#endif

    var attempts: Int = .zero
    while true {
      console.show("숫자를 입력하세요")
      guard let line = await console.readLine(),
            let guess = parser.parse(line) else {
        console.show("올바르지 않은 입력값입니다")
        continue
      }
      attempts += 1

      switch judge.judge(answer: answer, guess: guess) {
        case .correct:
          console.show("정답입니다!")
          return attempts
        case .nothing:
          console.show("Nothing")
        case let .strikeAndBall(s, b):
          console.show([s > .zero ? "\(s)스트라이크" : nil,
                        b > .zero ? "\(b)볼" : nil].compactMap { $0 }.joined(separator: " "))
      }
    }
  }
}
