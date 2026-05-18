# 5주차 실습 과제 — H2까지 구현 후 PostgreSQL 로 이어하기

모든 학습자가 **동일한 순서**로 진행한다.

1. **1단계**: H2(파일)로 저장되는 Todo REST API 까지 완료  
2. **2단계**: **같은 프로젝트·같은 Java 코드**로 **PostgreSQL** 에 붙였을 때 동일 API 동작 증명  
3. **3단계 이후**(선택): 쿼리 확장 · 관계 매핑 · BaseEntity 등

에러 발생 시 터미널 로그 **마지막 30줄**을 남긴다.

---

## 제출용 전체 따라하기 순서

아래 순서대로 진행하면 됩니다. 중간 단계를 건너뛰지 않습니다.

| 순서 | 해야 할 일 | 확인 방법 |
|------|------------|-----------|
| 1 | `pom.xml` 의존성 확인 | Web, Data JPA, H2, PostgreSQL Driver |
| 2 | 프로필 설정 파일 3개 생성 | `application.properties`, `application-h2.properties`, `application-pg.properties` |
| 3 | `spring.profiles.active=h2`로 실행 | H2 Console 접속 |
| 4 | `Todo` 엔티티 작성 | H2 Console에서 `TODOS` 테이블 확인 |
| 5 | Repository/Service/Controller 작성 | Spring Boot 서버 에러 없이 실행 |
| 6 | Postman으로 H2 API 검증 | POST 후 GET에서 데이터 확인 |
| 7 | 서버 재시작 후 H2 재검증 | 데이터 유지 확인 |
| 8 | PostgreSQL `tododb` 생성 | `CREATE DATABASE tododb;` |
| 9 | `spring.profiles.active=pg`로 전환 | 서버가 PostgreSQL에 연결됨 |
| 10 | Postman으로 PostgreSQL API 검증 | 같은 URL로 POST/GET 성공 |

### 중간 체크포인트

- **체크포인트 A**: `http://localhost:8080/h2-console` 접속 성공
- **체크포인트 B**: H2 Console에 `TODOS` 테이블 생성
- **체크포인트 C**: Postman `POST /api/todos` 응답이 `201 Created`
- **체크포인트 D**: 서버 재시작 후에도 H2 `GET /api/todos`에 데이터가 남아 있음
- **체크포인트 E**: PostgreSQL 전환 후 같은 API가 동작

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

### 파일별 작성 위치

| 파일 | 위치 예시 |
|------|-----------|
| 공통 설정 | `src/main/resources/application.properties` |
| H2 설정 | `src/main/resources/application-h2.properties` |
| PostgreSQL 설정 | `src/main/resources/application-pg.properties` |
| Todo 엔티티 | `src/main/java/.../domain/Todo.java` |
| Repository | `src/main/java/.../domain/TodoRepository.java` |
| Service | `src/main/java/.../service/TodoService.java` |
| Controller | `src/main/java/.../controller/TodoController.java` |

### 제출 증명 (1단계)

- Postman 또는 동등 도구: **POST 후 GET** 스크린샷 1장 이상  
- **서버 재시작 후** GET 했을 때 데이터가 그대로인 **스크린샷 또는 짧은 설명**

### README 에 적기

- JDK 버전, `./mvnw spring-boot:run`  
- 1단계에서 쓴 H2 JDBC URL 한 줄 요약  
- H2에서 테스트한 API 목록 (`GET`, `POST`, `DELETE` 등)

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

### PostgreSQL 전환 확인 순서

1. `application.properties`에서 `spring.profiles.active=pg` 확인
2. 서버 실행 로그에서 PostgreSQL 연결 에러가 없는지 확인
3. Postman에서 `GET http://localhost:8080/api/todos`
4. 빈 배열이면 정상일 수 있음. H2 데이터가 자동으로 옮겨지는 것은 아님
5. `POST /api/todos`로 새 데이터를 넣고 다시 `GET`

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
- README와 스크린샷만 봐도 실행 순서와 결과를 알 수 있게 정리  

## 팁

- `ddl-auto=update` 는 **학습 환경**용. 운영 서버에는 다른 전략을 쓴다.  
- H2 에서 채워 둔 데이터는 **PostgreSQL 로 자동 이전되지 않는다** — 2단계 입장에서는 새로 입력하거나 과제에서는 그 사실만 README 에 적어도 된다.
- 막히면 “어느 체크포인트에서 실패했는지”를 먼저 적고 질문한다.
