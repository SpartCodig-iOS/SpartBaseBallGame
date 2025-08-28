//
//  GuessParser.swift
//  SpartBaseBallGame
//
//  Created by Wonji Suh  on 8/28/25.
//

import Foundation

/// 1) Parser: 입력 파싱
struct GuessParser: Sendable {
  let digits: Int
  let forbidLeadingZero: Bool

  init(digits: Int, forbidLeadingZero: Bool = true) {
    precondition((1...10).contains(digits))
    self.digits = digits
    self.forbidLeadingZero = forbidLeadingZero
  }

  // MARK: - 입력 파싱
  func parse(_ input: String) -> [Int]? {
    let s = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard s.count == digits, s.allSatisfy(\.isNumber) else { return nil }
    if forbidLeadingZero && s.first == "0" { return nil }
    let nums = s.compactMap { Int(String($0)) }
    guard Set(nums).count == digits else { return nil } // 중복 금지
    return nums
  }
}

