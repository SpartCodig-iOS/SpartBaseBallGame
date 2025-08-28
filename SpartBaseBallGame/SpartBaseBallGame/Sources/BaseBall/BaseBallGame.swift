//
//  BaseBallGame.swift
//  SpartBaseBallGame
//
//  Created by Wonji Suh  on 8/27/25.
//

import Foundation
import LogMacro

actor BaseBallGame {
  private let digits: Int
  private let generator: AnswerGeneratorProtocol
  private let parser: GuessParser
  private let judgeEngine: JudgeEngine
  private let console: IOProvider
  private var records: GameRecord
  private let menu = MenuAction()
  private let runner: RoundRunner

  init(
    digits: Int = 3,
    generator: AnswerGeneratorProtocol = RandomAnswerGenerator(),
    judgeEngine: JudgeEngine = .init(),
    console: IOProvider = ConsoleIO(),
    records:   GameRecord = .init()
  ) {
    self.digits = digits
    self.records = records
    self.generator = generator
    self.parser = GuessParser(digits: digits, forbidLeadingZero: true)
    self.judgeEngine = judgeEngine
    self.console = console
    self.records = records
    self.runner = RoundRunner(digits: digits, generator: generator, parser: parser , judge: judgeEngine, console: console)
  }


  // MARK: - 게임시작
  func start() async {
    while true {
      switch await menu.ask(using: console) {
        case .startGame:
          let attempts = await runner.run()
          await records.saveRecord(attempts)
        case .showRecords:
          await records.showRecords(using: console)
        case .invalid:
          console.show("올바르지 않은 입력입니다. 1~3 중 하나를 입력해주세요.")
        case .quit:
          console.show("프로그램을 종료합니다.")
          return
      }
    }
  }
}
