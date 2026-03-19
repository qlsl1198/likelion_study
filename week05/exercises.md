# 5주차 실습 문제

## 실습 1: 엔티티 설계 (30분)

### 목표
JPA 엔티티를 설계하고 생성합니다.

### 문제
다음 요구사항을 만족하는 엔티티를 만드세요:

1. **Todo 엔티티**
   - id (Long, 자동 생성)
   - title (String, 필수, 최대 100자)
   - description (String, 선택, 최대 500자)
   - completed (boolean, 기본값: false)
   - createdAt (LocalDateTime, 자동 설정)
   - updatedAt (LocalDateTime, 자동 설정)

2. **BaseEntity 생성**
   - 공통 필드를 BaseEntity로 분리
   - @MappedSuperclass 사용

### 제출물
- BaseEntity.java
- Todo.java
- 실행 결과 스크린샷 (테이블 생성 확인)

---

## 실습 2: Repository 및 쿼리 메서드 (40분)

### 목표
Spring Data JPA Repository를 만들고 쿼리 메서드를 작성합니다.

### 문제
다음 쿼리 메서드를 만드세요:

1. **기본 메서드**
   - findAll()
   - findById(Long id)
   - save(Todo todo)
   - deleteById(Long id)

2. **커스텀 쿼리 메서드**
   - findByCompleted(boolean completed)
   - findByTitleContaining(String keyword)
   - findByTitleAndCompleted(String title, boolean completed)
   - countByCompleted(boolean completed)
   - existsByTitle(String title)

3. **정렬 및 페이징**
   - findByCompletedOrderByCreatedAtDesc(boolean completed)
   - findAll(Pageable pageable)

### 제출물
- TodoRepository.java
- 테스트 코드 또는 실행 결과

---

## 실습 3: @Query 사용하기 (30분)

### 목표
@Query 어노테이션을 사용하여 커스텀 쿼리를 작성합니다.

### 문제
다음 쿼리를 @Query로 작성하세요:

1. **JPQL 쿼리**
   - 완료된 Todo 중에서 제목에 특정 키워드가 포함된 것 조회
   - 생성일 기준 최근 7일 이내의 Todo 조회

2. **네이티브 쿼리**
   - 완료되지 않은 Todo 개수 조회
   - 특정 날짜 이후 생성된 Todo 조회

3. **수정 쿼리**
   - 특정 ID의 Todo를 완료 처리
   - @Modifying 사용

### 제출물
- TodoRepository.java (수정)
- 실행 결과

---

## 실습 4: 엔티티 관계 매핑 (50분)

### 목표
엔티티 간 관계를 설정합니다.

### 문제
다음 관계를 구현하세요:

1. **User 엔티티 생성**
   - id, username, email, createdAt

2. **Todo와 User 관계**
   - User (1) -----< (N) Todo
   - @ManyToOne, @OneToMany 사용
   - FetchType.LAZY 사용

3. **Repository 수정**
   - findByUserId(Long userId)
   - findByUserAndCompleted(User user, boolean completed)

4. **Service 수정**
   - 사용자별 Todo 조회 기능 추가

### 제출물
- User.java
- 수정된 Todo.java
- UserRepository.java
- 수정된 TodoRepository.java
- 실행 결과 스크린샷

---

## 실습 5: 완전한 Todo API 서버 (50분)

### 목표
데이터베이스 연동이 완료된 Todo API 서버를 만듭니다.

### 문제
다음 기능을 구현하세요:

1. **데이터베이스 설정**
   - PostgreSQL 또는 H2 설정
   - application.properties 작성

2. **엔티티**
   - User, Todo 엔티티
   - 관계 매핑

3. **Repository**
   - 모든 필요한 쿼리 메서드

4. **Service**
   - 비즈니스 로직 구현

5. **Controller**
   - REST API 엔드포인트
   - 사용자별 Todo 조회: GET `/api/users/{userId}/todos`

6. **테스트**
   - Postman으로 모든 API 테스트
   - 데이터베이스에 데이터 저장 확인

### 제출물
- 전체 프로젝트 파일
- Postman 테스트 결과
- 데이터베이스 스크린샷

---

## 종합 실습: 블로그 API (선택사항)

### 목표
복잡한 관계를 가진 블로그 API를 만듭니다.

### 요구사항
1. **엔티티**
   - User: 사용자
   - Post: 게시글 (User와 관계)
   - Comment: 댓글 (Post, User와 관계)
   - Tag: 태그 (Post와 ManyToMany 관계)

2. **API**
   - 사용자 CRUD
   - 게시글 CRUD
   - 댓글 CRUD
   - 태그 관리
   - 게시글 검색 (제목, 내용, 태그)

3. **고급 기능**
   - 페이징
   - 정렬
   - 검색

### 제출물
- 전체 프로젝트
- API 문서
- 테스트 결과

---

## 평가 기준

| 실습 | 배점 | 평가 기준 |
|------|------|-----------|
| 실습 1 | 20점 | 엔티티 정상 생성 |
| 실습 2 | 25점 | 쿼리 메서드 정상 작동 |
| 실습 3 | 20점 | @Query 정상 사용 |
| 실습 4 | 20점 | 관계 매핑 정상 작동 |
| 실습 5 | 15점 | 완전한 API 서버 |
| 종합 실습 | 보너스 | 추가 점수 |

**총점: 100점**

---

## 제출 방법
1. 각 실습을 개별 패키지로 구성
2. GitHub에 업로드
3. README.md에 데이터베이스 스키마 설명 추가
4. 실행 방법 문서화

## 팁
- 데이터베이스 스키마를 먼저 설계하기
- 관계 매핑 시 FetchType 신중히 선택하기
- N+1 문제 주의하기
- 트랜잭션 관리하기

