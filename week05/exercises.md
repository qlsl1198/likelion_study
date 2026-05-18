# 5주차 실습 과제 — H2까지 구현 후 PostgreSQL 로 이어하기

모든 학습자가 **동일한 순서**로 진행한다.

1. **1단계**: H2(파일)로 저장되는 Todo REST API 까지 완료  
2. **2단계**: **같은 프로젝트·같은 Java 코드**로 **PostgreSQL** 에 붙였을 때 동일 API 동작 증명  
3. **3단계 이후**(선택): 쿼리 확장 · 관계 매핑 · BaseEntity 등

에러 발생 시 터미널 로그 **마지막 30줄**을 남긴다.

---

## 1단계: H2 + JPA 로 Todo 저장·조회 (필수)

### 목표

- 서버를 껐다 켜도 **목록이 유지**(파일 저장 H2)  
- 다음 API 준비:  
  - `GET /api/todos`  
  - `POST /api/todos` (JSON 에 `title`, `description`)  
  - `GET /api/todos/{id}`  
  - `DELETE /api/todos/{id}`  

### 체크리스트

1. Dependencies: Spring Web + Spring Data JPA + **H2** + **PostgreSQL Driver** (2단계를 위해 두 드라이버 함께 두는 것을 권장)  
2. **`presentation.md` / `materials.md`** 와 같은 방식으로 **프로필** 구성 후 `spring.profiles.active=h2`  
3. `Todo` 엔티티, `TodoRepository`, `TodoService`, `TodoController` 구현 (강의 `materials.md` 예시 활용 가능)  

### 제출 증명 (1단계)

- Postman 또는 동등 도구: **POST 후 GET** 스크린샷 1장 이상  
- **서버 재시작 후** GET 했을 때 데이터가 그대로인 **스크린샷 또는 짧은 설명**

### README 에 적기

- JDK 버전, `./mvnw spring-boot:run`  
- 1단계에서 쓴 H2 JDBC URL 한 줄 요약  

---

## 2단계: 같은 코드로 PostgreSQL 전환 (필수)

### 목표

- **Java 클래스 수정 없이** (또는 프로필/설정만으로) 저장소만 PostgreSQL 로 변경  
- 1단계와 **동일한 URL** 에서 목록 조회 · 생성 가능  

### 해야 할 일

1. PostgreSQL 에 `tododb` 생성 (`CREATE DATABASE tododb;`)  
2. `application-pg.properties` 의 접속 정보(사용자·비밀번호)를 본인 환경으로 수정  
3. `spring.profiles.active=pg` 로 전환 후 기동 확인  
4. Postman 로 `GET /api/todos` · `POST /api/todos` 가 정상 동작하는지 확인 (DB가 비었으니 필요 시 새로 POST)  

### 제출 증명 (2단계)

- **`pg` 프로필** 사용 중임을 README 한 줄 또는 스크린샷으로 표시 (예: `spring.profiles.active=pg`)  
- PostgreSQL 상태에서 POST·GET 결과 **스크린샷 1장 이상**

### 비밀번호·보안

- `application-pg.properties` 에 **실제 비밀번호를 Git 에 올리지 말 것** → `example` 파일만 저장소에 포함하고 로컬은 `.gitignore` 처리 권장  

---

## 3단계·선택: 쿼리 메서드로 검색 기능

### 문제

Repository 에 아래 중 **2개 이상** 구현 후 Controller 까지 연결.

- `findByCompleted` (이미 쓸 수 있음)  
- `findByTitleContainingIgnoreCase`  
- `countByCompleted` 등  

제출물: 새 URL 호출 캡처  

---

## 4단계·선택: `@Query` 한 줄

JPQL 또는 `nativeQuery` 로 조건 검색 하나를 직접 작성.

제출물: Repository 메서드 + 호출 결과 캡처  

---

## 5단계·선택: User — Todo 1:N

`User`, `Todo` 엔티티 관계 매핑 + `GET /api/users/{userId}/todos` 등 사용자별 목록 API.

제출물: 엔티티·컨트롤러 일부 + 캡처  

---

## 6단계·선택: `@MappedSuperclass` BaseEntity

생성 시간 등 공통 필드를 부모 클래스로 분리.

제출물: `BaseEntity` + 수정된 `Todo`  

---

## 평가 기준 (예시)

| 항목 | 배점 | 평가 |
|------|------|------|
| 1단계 H2 | 55 | 엔티티·Repository·Service·Controller · 재시작 후 유지 증명 |
| 2단계 PostgreSQL | 35 | 프로필/설정 전환 후 동일 API 동작 증명, 비번 커밋 여부 처리 |
| 3단계 선택 | 5 | 검색 라우트 2종 이상 |
| 4~6단계 | 5 또는 보너스 | 과제 채택 시 가산 |

**총 100점** — **핵심은 1단계와 2단계를 순서대로 완료**하는 것이다.

---

## 제출 방법

- 조직 저장소 규칙을 따름  
- 불필요한 `target/`, 로컬 DB 파일은 `.gitignore`  

## 팁

- `ddl-auto=update` 는 **학습 환경**용. 운영 서버에는 다른 전략을 쓴다.  
- H2 에서 채워 둔 데이터는 **PostgreSQL 로 자동 이전되지 않는다** — 2단계 입장에서는 새로 입력하거나 과제에서는 그 사실만 README 에 적어도 된다.
