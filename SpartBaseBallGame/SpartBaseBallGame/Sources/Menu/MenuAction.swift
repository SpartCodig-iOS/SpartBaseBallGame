//
//  MenuAction.swift
//  SpartBaseBallGame
//
//  Created by Wonji Suh  on 8/28/25.
//

import Foundation

enum MenuType {
  case startGame, showRecords, quit, invalid
}

struct MenuAction: Sendable {
  func ask(using io: IOProvider) async -> MenuType {
    io.show("""
        환영합니다! 원하시는 번호를 입력해주세요
        1. 게임 시작하기  2. 게임 기록 보기  3. 종료하기
        """, )

    guard let line = await io.readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
          let n = Int(line) else { return .invalid }

    switch n {
      case 1: return .startGame
      case 2: return .showRecords
      case 3: return .quit
      default: return .invalid
    }
  }
}
