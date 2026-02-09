## RIBs Practice Project

### 프로젝트 소개
RIBs 아키텍처의 기본 구조와 모듈 간 흐름을 이해하기 위해 구현한 iOS 학습 프로젝트입니다.  
간단한 기능을 가진 두 개의 탭을 통해 Parent–Child RIB 구조와 Router 기반 화면 전환을 직접 구현해보았습니다.

---

### 앱 구성

- TodoList
- UserInfo
- UserInfoDetail (Child RIB)

---

### RIB 구조
Root
- TodoList
- UserInfo
  - UserInfoDetail

각 모듈은 다음 구성 요소로 이루어져 있습니다.

- Router
- Interactor
- Builder
- ViewController

---

### 구현 포인트

- Builder를 통한 RIB 생성 흐름 구현
- Router를 통한 navigation 관리
- Interactor 중심의 비즈니스 로직 처리
- Parent–Child RIB attach / detach 구조 이해
- 간단한 Dependency Injection 흐름 적용

---

### 학습 내용

이 프로젝트를 통해 다음을 학습했습니다.

- RIB 모듈의 역할과 책임 분리
- RIB Tree 구조 이해
- Router 기반 화면 전환 방식
- Builder를 통한 의존성 연결
- Interactor lifecycle 이해

---

### 사용 기술
- Swift
- UIKit
- RIBs Architecture
- SnapKit

---

### 프로젝트 목적
RIBs 아키텍처를 실제 코드로 구현해보며 구조와 동작 방식을 이해하는 것을 목표로 했습니다.
