# Bolt Project Progress Report

**Date:** 2026-01-09
**Status:** Phase 1 MVP (Core Implementation Completed)
**Version:** 0.1.0

---

## 1. Summary (요약)
Phase 1 MVP의 핵심 목표인 **"앱 실행, 인증, 즉시 메모 작성 및 로컬 저장"** 기능을 구현 완료했습니다.
기술적인 호환성 문제로 인해 로컬 데이터베이스를 Isar에서 **Drift (SQLite)**로 변경하였으며, Clean Architecture와 Riverpod 3.0 기반의 견고한 아키텍처를 구축했습니다.

---

## 2. Completed Features (완료된 기능)

### ✅ Project Setup
- **Architecture:** Clean Architecture (Layered: Presentation / Domain / Data)
- **State Management:** Riverpod 3.0 (Code Generation, Notifier, Provider)
- **Routing:** GoRouter (Type-safe Routes, Redirection Logic)
- **Theme:** Dark Mode Default (`#121212` Background, `#FFD700` Primary)

### ✅ Feature: Authentication (인증)
- **Implementation:** `AuthRepository` (FlutterSecureStorage), `AuthController`.
- **UI:** `LoginScreen` (Mock "Connect Notion" Flow for MVP).
- **Logic:**
  - 앱 실행 시 토큰 존재 여부 확인.
  - 비로그인 상태 시 `/login`으로 자동 리다이렉트.
  - 로그인 성공 시 홈(`/`)으로 이동.
- **Test:** Fake Repository를 이용한 인증 흐름 테스트 완료.

### ✅ Feature: Instant Memo (메모)
- **Implementation:** `MemoRepository` (Drift), `MemoController`.
- **Database:** **Drift (SQLite)** 적용.
  - Table: `MemoItems` (Content, CreatedAt, SyncStatus).
  - Domain Entity: `Memo` (DB 모델과 분리하여 아키텍처 의존성 제거).
- **UI:** `MemoScreen`.
  - **Instant Write:** 화면 진입 즉시 키보드 활성화 (`autofocus`).
  - **Interaction:** 작성 후 엔터/전송 버튼 시 즉시 DB 저장 및 리스트 갱신.
  - **Feedback:** 저장 완료 시 "Saved!" 스낵바 노출.
- **Test:** 로그인부터 메모 작성, 저장, 리스트 확인까지의 전체 시나리오 테스트(Integration Test) 통과.

---

## 3. Technical Decisions & Changes (기술적 의사결정)

### 🔄 Database Change: Isar → Drift
- **Reason:** Isar 3.1.0과 최신 Riverpod Generator / Build Runner 간의 심각한 의존성 충돌 발생.
- **Solution:** Flutter 생태계에서 가장 안정적이고 Riverpod와 호환성이 뛰어난 **Drift (SQLite)**로 기술 스택 변경.
- **Impact:** `MemoItem` 클래스 생성 및 Stream 구독 로직이 Drift 방식으로 최적화됨.

### 🏗️ Domain Entity Separation
- **Pattern:** `MemoItem`(DB Table)과 `Memo`(Domain Entity)를 분리.
- **Reason:** Drift가 생성하는 데이터 클래스를 UI나 비즈니스 로직에서 직접 의존하지 않도록 하여, Clean Architecture 원칙 준수 및 테스트 용이성 확보.

### ⚠️ Known Tech Debt (기술 부채)
- **Static Analysis Issue:** Freezed로 생성된 클래스(`AuthState`)의 Extension Method(`map`, `when`)가 특정 환경(CLI/Test)에서 인식되지 않는 문제 발생.
- **Temporary Fix:** `runtimeType` 문자열 비교 및 `dynamic` 캐스팅을 통해 런타임 동작 보장.
- **Plan:** 추후 IDE 환경 설정 점검 또는 Dart/Analyzer 버전 업데이트 후 정적 타입 체크(`is`, `switch`)로 리팩토링 예정.

---

## 4. Next Steps (향후 계획)

### Phase 2: Stability & Sync (Current Priority)
1. **Notion API Integration:**
   - 실제 Notion API 클라이언트 구현.
   - Mocking 된 `exchangeCodeForToken`을 실제 서버 통신으로 교체.
2. **Background Sync:**
   - `WorkManager` (Android) / `Background Fetch` (iOS) 도입.
   - 오프라인 상태에서 저장된 메모를 백그라운드에서 Notion으로 전송.
3. **Error Handling:**
   - 네트워크 재시도(Retry) 로직 고도화.

### Phase 3: Polish
- 다크 모드 UI 디테일 수정.
- 공유하기(Share Intent) 기능 추가.

---
**Current Test Coverage:**
`test/widget_test.dart`: Full Integration Flow (Pass)
