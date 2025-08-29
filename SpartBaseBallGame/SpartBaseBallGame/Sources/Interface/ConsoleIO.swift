//
//  ConsoleIO.swift
//  SpartBaseBallGame
//
//  Created by Wonji Suh  on 8/28/25.
//

import Foundation
import LogMacro

struct ConsoleIO: IOProvider {
  func show(_ message: String) {
    #logDebug(message)
  }

  // MARK: - readLine 비동기 래핑
  func readLine() async -> String? {
    await withCheckedContinuation { continuation in
      Task.detached { continuation.resume(returning: Swift.readLine()) }
    }
  }
}
