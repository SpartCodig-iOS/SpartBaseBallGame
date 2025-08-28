//
//  JudgeEngine.swift
//  SpartBaseBallGame
//
//  Created by Wonji Suh  on 8/28/25.
//

import Foundation

/// 2) Judge: 판정 로직
struct JudgeEngine: Sendable {
  func judge(answer: [Int], guess: [Int]) -> JudgeResult {
    let strike = zip(answer, guess).filter { $0 == $1 }.count
    let ball = Set(answer).intersection(guess).count - strike
    if strike == answer.count { return .correct }
    if strike == .zero && ball == .zero { return .nothing }
    return .strikeAndBall(strike: strike, ball: ball)
  }
}

