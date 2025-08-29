# SpartBaseBallGame
내일배움 캠프 2주차  문법 과제

이 저장소는 Swift 문법 학습을 위해 작성된 과제 코드와 컨벤션을 포함하고 있습니다.  
코드를 작성할 때는 **컨벤션**과 **Git 전략**을 준수하며, 협업 시 일관된 개발 환경을 유지하는 것을 목표로 합니다.

---

## 📑 컨벤션
- [공통 컨벤션](./Convention/Common.md)  
모든 Swift 코드에서 반드시 준수해야 하는 컨벤션을 정의합니다.

---

## 🐈‍⬛ Git 전략

### 🔀 Branching Strategy
- **Origin(main branch)**
- **Origin(dev branch)**
- **Local(feature branch)**

#### Branch 종류
- `main`
- `dev`
- `feature/*`
- `fix/*`

#### 작업 순서
1. Origin의 **dev** 브랜치를 Pull  
2. Local에서 **feature/과제명** 브랜치를 생성  
3. **feature** 브랜치에서 개발 진행  
4. Local → Origin으로 **feature** 브랜치 Push  
5. Origin의 **feature** → Origin의 **dev** 로 Pull Request 생성  
6. Origin **dev** 브랜치에서 충돌 해결 및 Merge  
7. Local **dev** 브랜치에서 Origin **dev**를 Fetch & Rebase  

---

## 💾 Commit 가이드
- [Commit 메시지 규칙](./.github/.gitMessage.md)  
일관된 커밋 메시지를 작성하기 위한 가이드입니다.

---


## 📘 과제 소개
### 🎯 과제 주제
- Swift 기본 문법을 활용하여 **숫자 야구(Baseball) 게임**을 구현합니다.
- 콘솔 기반 프로그램으로, 사용자가 숫자를 입력해 정답을 맞히는 구조입니다.

### 📌 요구 사항
1. 랜덤한 정답 숫자 생성 (중복 없는 n자리 수)
2. 사용자 입력 처리 (`readLine()` 사용 → 비동기 처리 개선)
3. 정답과 입력값을 비교하여 **스트라이크 / 볼** 판정
4. 정답을 맞히면 게임 종료 후 다시 시작 가능
5. 잘못된 입력(중복 숫자, 범위 오류 등)에 대한 예외 처리

### 🛠️ 학습 목표
- **Swift 기본 문법** (변수, 함수, 조건문, 반복문)
- **컬렉션 활용** (Array, Set)
- **함수 분리와 모듈화**
- **비동기 처리**(`Task`, `withCheckedContinuation`)
- **파일 분리 리팩토링**을 통한 코드 구조화

# 📌 트러블슈팅
이 프로젝트를 진행하면서 중점적으로 개선한 부분은 다음과 같습니다.

### 1) `readLine()` 비동기 처리
- 기존의 `readLine()`은 입력 대기 동안 프로그램 전체를 멈추게 하는 **동기 방식**이었음.  
- `Task`와 `withCheckedContinuation`을 활용하여 **비동기 입력 처리**로 개선.  
- 입력 대기 중에도 안내 문구 출력 등 다른 동작과 병렬 실행 가능.  

### 2) 파일 분리 리팩토링
- 초기 코드가 `main.swift`에 모두 섞여 있어 가독성과 유지보수성이 떨어짐.  
- `AnswerGenerator.swift`, `InputParser.swift`, `Judge.swift`, `Game.swift` 등으로 **역할별 파일 분리**.  
- 각 기능의 책임이 명확해져 수정과 확장이 용이해짐.  

---

## 🚀 실행 방법
```bash
swift run
