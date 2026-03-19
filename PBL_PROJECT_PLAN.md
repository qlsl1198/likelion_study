# PBL 프로젝트 계획서: Todo 관리 웹 애플리케이션

## 📋 프로젝트 개요

### 프로젝트명
**TodoMaster** - 개인 Todo 관리 웹 애플리케이션

### 프로젝트 목표
8주 동안 React와 Spring Boot를 활용하여 완전한 풀스택 웹 애플리케이션을 개발하고 배포한다.

### 기술 스택
- **프론트엔드**: React, React Router, Axios
- **백엔드**: Spring Boot, Spring Data JPA, Spring Security
- **데이터베이스**: PostgreSQL
- **인증**: JWT
- **배포**: Vercel (프론트엔드), Railway (백엔드)

---

## 📅 주차별 프로젝트 진행 계획

### 1주차: 프로젝트 기초 설정
**목표**: 개발 환경 구축 및 프로젝트 초기 설정

**작업 내용**:
- [ ] 개발 환경 구축 (Node.js, Java, IDE)
- [ ] Git 저장소 생성 및 초기 커밋
- [ ] React 프로젝트 생성 (`create-react-app`)
- [ ] Spring Boot 프로젝트 생성 (Spring Initializr)
- [ ] 프로젝트 구조 설계
- [ ] README.md 작성

**산출물**:
- React 프로젝트 기본 구조
- Spring Boot 프로젝트 기본 구조
- GitHub 저장소

---

### 2주차: React 기초 구현
**목표**: 프론트엔드 기본 UI 구현

**작업 내용**:
- [ ] Todo 리스트 컴포넌트 구현
- [ ] Todo 추가 폼 구현
- [ ] Todo 완료/삭제 기능 구현
- [ ] 기본 스타일링 (CSS 또는 styled-components)
- [ ] 로컬 스토리지로 데이터 저장 (임시)

**산출물**:
- Todo 리스트 UI
- 기본 CRUD 기능 (프론트엔드만)

---

### 3주차: React 심화 및 라우팅
**목표**: React 고급 기능 및 라우팅 구현

**작업 내용**:
- [ ] React Router 설정
- [ ] 페이지 분리 (홈, Todo 리스트, 통계)
- [ ] Context API로 전역 상태 관리
- [ ] useEffect로 로컬 스토리지 연동
- [ ] 검색 및 필터링 기능 추가

**산출물**:
- 멀티 페이지 애플리케이션
- 전역 상태 관리 구현

---

### 4주차: Spring Boot API 구현
**목표**: 백엔드 REST API 구현

**작업 내용**:
- [ ] Todo 엔티티 설계 및 생성
- [ ] TodoRepository 구현
- [ ] TodoService 구현
- [ ] TodoController 구현 (CRUD API)
- [ ] DTO 생성 및 사용
- [ ] Postman으로 API 테스트

**산출물**:
- 완전한 REST API 서버
- API 문서

---

### 5주차: 데이터베이스 연동
**목표**: 데이터베이스 연동 및 관계 설정

**작업 내용**:
- [ ] PostgreSQL 데이터베이스 설정
- [ ] User 엔티티 생성
- [ ] User와 Todo 관계 설정
- [ ] 쿼리 메서드 구현
- [ ] 데이터베이스 테스트

**산출물**:
- 데이터베이스 연동 완료
- 사용자별 Todo 관리 기능

---

### 6주차: 프론트엔드-백엔드 연동
**목표**: React와 Spring Boot 통합

**작업 내용**:
- [ ] CORS 설정
- [ ] Axios 설정 및 API 호출 구현
- [ ] 커스텀 Hook으로 API 로직 분리
- [ ] 에러 처리 구현
- [ ] 로딩 상태 관리
- [ ] 전체 기능 통합 테스트

**산출물**:
- 완전히 연동된 풀스택 애플리케이션
- 에러 처리 및 로딩 상태 구현

---

### 7주차: 인증/인가 구현
**목표**: 사용자 인증 기능 추가

**작업 내용**:
- [ ] Spring Security 설정
- [ ] JWT 토큰 생성 및 검증
- [ ] 회원가입/로그인 API 구현
- [ ] React에서 인증 상태 관리
- [ ] 보호된 라우트 구현
- [ ] 사용자별 Todo 관리

**산출물**:
- 완전한 인증 시스템
- 사용자별 데이터 분리

---

### 8주차: 배포 및 최종 완성
**목표**: 프로젝트 배포 및 발표 준비

**작업 내용**:
- [ ] 프로젝트 빌드 및 최적화
- [ ] Vercel에 프론트엔드 배포
- [ ] Railway에 백엔드 배포
- [ ] 프로덕션 데이터베이스 설정
- [ ] 코드 리뷰 및 리팩토링
- [ ] 문서화 (README, API 문서)
- [ ] 발표 자료 준비

**산출물**:
- 배포된 웹 애플리케이션
- 완성된 프로젝트 코드
- 발표 자료

---

## 🎯 핵심 기능 명세

### 필수 기능
1. **사용자 인증**
   - 회원가입
   - 로그인/로그아웃
   - JWT 기반 인증

2. **Todo 관리**
   - Todo 생성
   - Todo 조회 (목록, 상세)
   - Todo 수정
   - Todo 삭제
   - Todo 완료 표시

3. **사용자 경험**
   - 로딩 상태 표시
   - 에러 처리
   - 반응형 디자인

### 추가 기능 (선택사항)
1. **고급 기능**
   - Todo 카테고리/태그
   - 우선순위 설정
   - 마감일 설정
   - 검색 및 필터링
   - 정렬 기능

2. **통계 및 분석**
   - 완료율 통계
   - 일별/주별 통계
   - 시각화 (차트)

3. **협업 기능**
   - Todo 공유
   - 댓글 기능

---

## 📊 평가 기준

### 개발 과정 평가 (60%)
- 주차별 과제 완성도: 40%
- 코드 품질: 10%
- Git 커밋 이력: 10%

### 최종 프로젝트 평가 (40%)
- 기능 완성도: 20%
- 코드 품질 및 구조: 10%
- 배포 및 문서화: 10%

### 보너스 점수
- 추가 기능 구현: +10%
- 우수한 UI/UX: +5%
- 성능 최적화: +5%

---

## 📝 프로젝트 관리

### Git 브랜치 전략
- `main`: 프로덕션 브랜치
- `develop`: 개발 브랜치
- `feature/기능명`: 기능 개발 브랜치
- `fix/버그명`: 버그 수정 브랜치

### 커밋 메시지 규칙
```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 수정
style: 코드 포맷팅
refactor: 코드 리팩토링
test: 테스트 추가
chore: 빌드 설정 등
```

### 주간 회고
매주 마지막에 다음을 작성:
- 이번 주 완료한 작업
- 어려웠던 점 및 해결 방법
- 다음 주 계획

---

## 🛠️ 개발 가이드라인

### 코드 스타일
- **React**: 함수형 컴포넌트, Hooks 사용
- **Java**: Java 코딩 컨벤션 준수
- **네이밍**: 명확하고 일관된 네이밍

### 파일 구조
```
project/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── contexts/
│   │   ├── api/
│   │   └── utils/
│   └── public/
├── backend/
│   └── src/
│       └── main/
│           ├── java/
│           │   └── com/likelion/
│           │       ├── controller/
│           │       ├── service/
│           │       ├── repository/
│           │       ├── entity/
│           │       └── dto/
│           └── resources/
└── README.md
```

### 문서화
- README.md: 프로젝트 개요, 설치 방법, 실행 방법
- API 문서: 엔드포인트 설명
- 코드 주석: 복잡한 로직 설명

---

## 🎓 학습 목표 달성 체크리스트

### React
- [ ] 컴포넌트 기반 개발
- [ ] Hooks 활용
- [ ] 상태 관리
- [ ] 라우팅
- [ ] API 통신

### Spring Boot
- [ ] REST API 개발
- [ ] 데이터베이스 연동
- [ ] 인증/인가
- [ ] 예외 처리
- [ ] 테스트 작성

### 풀스택
- [ ] 프론트엔드-백엔드 통합
- [ ] 배포
- [ ] 프로젝트 관리

---

## 📚 참고 자료

### 공식 문서
- [React 공식 문서](https://react.dev/)
- [Spring Boot 공식 문서](https://spring.io/projects/spring-boot)
- [PostgreSQL 공식 문서](https://www.postgresql.org/docs/)

### 학습 자료
- 각 주차별 presentation.md 파일
- 각 주차별 materials.md 파일
- 각 주차별 exercises.md 파일

---

## 🚀 시작하기

1. **저장소 클론**
   ```bash
   git clone [your-repo-url]
   cd likelion_study
   ```

2. **프로젝트 생성**
   - React: `npx create-react-app frontend`
   - Spring Boot: Spring Initializr 사용

3. **개발 시작**
   - 1주차부터 순차적으로 진행
   - 각 주차별 실습 문제 해결
   - 주간 회고 작성

---

**행운을 빕니다! 🎉**

