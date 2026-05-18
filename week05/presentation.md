# 5주차: H2부터 PostgreSQL까지 — DB 연동 실습 한 줄 코스

**이번 주는 같은 코드**를 **먼저 H2**에서 돌린 뒤, **PostgreSQL로 옮겨 보는 과정**까지 한 번에 갑니다. 이론은 아래 표 두 줄만 읽고 **Lab 순서대로 따라 치면** 됩니다.

| 단어 | 이렇게만 기억 |
|------|----------------|
| `@Entity` 붙인 클래스 | DB에 만들어지는 **표 한 장**과 연결된다 |
| `JpaRepository` | `save`, `findAll` 같은 기능이 인터페이스에 **이미 포함**된다 |

**오늘 목표**: 4주차 API에 저장소를 붙인다 → **재시작해도 데이터 유지**(H2 파일) → **같은 API가 PostgreSQL에서도 동작**한다.

---

## 수업·실습 순서 (전원 동일 루트)

| 순서 | 내용 |
|------|------|
| 【Lab 0】 프로젝트 의존성 (H2 + PostgreSQL 드라이버 둘 다) |
| 【Lab 1】 **프로필로 H2** 연결 · H2 Console 확인 |
| 【Lab 2】 `Todo` 엔티티 |
| 【Lab 3】 `TodoRepository` |
| 【Lab 4】 `TodoService` + `TodoController` |
| 【Lab 5】 Postman으로 저장·목록·재실행 검증 (**H2**) |
| 【Lab 6】 **PostgreSQL 설치 요약 · DB 생성 · 프로필을 `pg`로 전환** |
| 【Lab 7】 Postman으로 **같은 API** 재검증 + (시간 되면) `findBy…` 라우트 |
| 【Lab 8·선택】 쿼리 메서드·`@Query`·관계 매핑 등 — `exercises.md` 참고 |

복붙용 설정·코드 블록은 **`materials.md`** 에 더 길게 정리되어 있다.

---

## 【Lab 0】 준비 (약 10분)

- **4주차 프로젝트**가 있으면 연다.
- 새로 받을 경우: https://start.spring.io/
  - **Dependencies**: **Spring Web**, **Spring Data JPA**, **H2 Database**, **PostgreSQL Driver**

```bash
./mvnw spring-boot:run
```

서버만 뜨면 OK (`localhost:8080` 은 에러 페이지여도 무방).

---

## 【Lab 1】 H2 로 먼저 연결 — 프로필 방식 (약 15분)

**프로필을 쓰는 이유**: Java 코드 수정 없이 `h2` ↔ `pg` 만 바꿔 끼우기 위해.

다음 세 파일은 `src/main/resources/` 에 둔다. (긴 버전은 `materials.md` 참고.)

**`application.properties`**

```properties
spring.application.name=todo-db
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.open-in-view=false

spring.profiles.active=h2
```

**`application-h2.properties`**

```properties
spring.datasource.url=jdbc:h2:file:~/likelion-todo;DB_CLOSE_DELAY=-1;AUTO_SERVER=TRUE
spring.datasource.username=sa
spring.datasource.password=
spring.datasource.driver-class-name=org.h2.Driver
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
```

**`application-pg.properties`** — 비번은 나중 Lab 6에서 본인 환경에 맞게 수정

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/tododb
spring.datasource.username=postgres
spring.datasource.password=YOUR_PASSWORD
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

**H2 Console**: `http://localhost:8080/h2-console` → JDBC URL이 **properties와 동일한지** 확인 후 Connect.

---

## 【Lab 2】 `Todo` 엔티티 (약 15분)

`Todo.java` 패키지만 본인 프로젝트에 맞추고 전체 복사한다. 코드는 **`materials.md`** 의 「Todo 엔티티 전체」 블록과 동일.

---

## 【Lab 3】 `TodoRepository` (약 10분)

`JpaRepository` 상속 인터페이스 + `findByCompleted`, `findByTitleContainingIgnoreCase` 포함. 코드는 **`materials.md`** 참고.

---

## 【Lab 4】 `TodoService` + `TodoController` (약 25분)

4주차와 같은 **Controller → Service → Repository** 흐름. 전체 예시는 **`materials.md`** 에 있다.

4주차에 **메모리 기반 Todo** 클래스·컨트롤러가 있다면 파일을 **정리해서 하나만** 남긴다.

---

## 【Lab 5】 Postman — H2 에서 검증 (약 10분)

| 단계 | Method | URL 예시 |
|------|--------|----------|
| 1 | GET | `http://localhost:8080/api/todos` |
| 2 | POST | `{"title":"첫 할일","description":"연습"`} |
| 3 | GET | 목록 재확인 |
| 4 | 서버 재시작 후 GET | 파일 H2 라면 데이터 유지 |

---

## 【Lab 6】 PostgreSQL 로 전환 (약 35~45분)

Java 코드 변경 없음. **설정·데이터만** 교체한다.

1. PostgreSQL 설치 또는 기존 인스턴스 사용 — [postgresql.org/download](https://www.postgresql.org/download/)
2. `CREATE DATABASE tododb;`
3. `application-pg.properties` 의 `YOUR_PASSWORD`(및 필요 시 username) 수정
4. `application.properties` 에서 **`spring.profiles.active=pg`**
5. 서버 재기동 후 연결 에러가 없으면 성공 단계 진입

---

## 【Lab 7】 같은 API 재검증 (약 10~15분)

`pg` 프로필로 Postman 재호출. 필요 시 새로 POST해서 데이터 채운 뒤 목록 확인.

**(시간 되면)** `GET /api/todos/search?completed=false` 등 Lab 7 예시 라우트는 `materials.md` 의 컨트롤러 참고 블록에 맞춰 추가.

---

## 【Lab 8·선택】 `exercises.md` 확장 과제

`@Query`, User와 Todo 관계, BaseEntity 분리 등은 **추가 실습**/과제 심화.

---

## 과제

`exercises.md` — **단계 1(H2)·단계 2(Postgresql)** 를 연속 과제 줄기로 확인.

---

## 다음 주

6주차에서는 이 API를 **React + Axios**로 호출한다. 백엔드에 **CORS** 열어두면 수업이 수월하다.
