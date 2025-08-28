//
//  IOProvider.swift
//  SpartBaseBallGame
//
//  Created by Wonji Suh  on 8/28/25.
//

import Foundation

protocol IOProvider {
  func show(_ message: String)
  func readLine() async -> String?
}
