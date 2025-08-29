//
//  RandomAnswerGenerator.swift
//  SpartBaseBallGame
//
//  Created by Wonji Suh  on 8/28/25.
//

import Foundation


struct RandomAnswerGenerator: AnswerGeneratorProtocol, Sendable {
  func make(digits: Int) -> [Int] {
    let first = Int.random(in: 1...9)
    var pool = Array(0...9).filter { $0 != first }
    pool.shuffle()
    return [first] + Array(pool.prefix(digits - 1))
  }
}
