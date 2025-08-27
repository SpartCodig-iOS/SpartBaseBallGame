//
//  GameManager.swift
//  SpartBaseBallGame
//
//  Created by Wonji Suh  on 8/27/25.
//

import Foundation
import Combine

actor GameManager {
  let baseBall = BaseBallGame()
  // MARK: - 야구 게임 시작
  func baseBallGameStart() async {
    await baseBall.start()
  }
}
