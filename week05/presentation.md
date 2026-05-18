# 5주차: Spring Boot JPA 실습 — H2에서 PostgreSQL까지

이번 주 목표는 “DB 이론을 오래 설명하기”가 아니라, **4주차 Todo API를 실제 DB에 저장되는 API로 바꾸는 것**입니다.

흐름은 하나입니다.

1. 먼저 설치가 필요 없는 **H2 파일 DB**로 성공 경험을 만든다.
2. 같은 Java 코드로 **PostgreSQL**에 연결한다.
3. 같은 API를 Postman으로 다시 검증한다.
4. 시간이 남으면 검색 API와 쿼리 메서드를 추가한다.

---

## 이 자료를 따라가는 방법

수업 중에는 아래 규칙대로만 진행합니다.

1. **파일 위치를 먼저 확인한다.**  
   예: `src/main/resources/application.properties`, `src/main/java/.../domain/Todo.java`
2. **코드를 한 번에 다 외우려고 하지 않는다.**  
   슬라이드의 코드를 그대로 타이핑하거나 복사하고, 패키지명만 본인 프로젝트에 맞춘다.
3. **파일 하나를 만들 때마다 실행 또는 확인을 한다.**  
   설정 파일을 만든 뒤 H2 Console 확인, Entity를 만든 뒤 테이블 확인, Controller를 만든 뒤 Postman 확인.
4. **에러가 나면 다음 단계로 넘어가지 않는다.**  
   터미널 마지막 20~30줄, Postman 상태 코드, H2 Console URL을 먼저 확인한다.

### 완성 기준

아래가 되면 5주차 핵심 실습은 성공입니다.

- H2 프로필에서 `POST /api/todos`로 Todo가 저장된다.
- 서버를 껐다 켜도 H2에 저장한 Todo가 남아 있다.
- `spring.profiles.active=pg`로 바꾼 뒤 PostgreSQL에서도 같은 API가 동작한다.
- H2와 PostgreSQL 전환 과정에서 Java 코드를 새로 고치지 않는다.

---

## 오늘 만들 결과물

수업이 끝나면 아래 API가 동작해야 합니다.

| 기능 | Method | URL | 설명 |
|------|--------|-----|------|
| Todo 목록 조회 | GET | `/api/todos` | 저장된 Todo 전체 조회 |
| Todo 단건 조회 | GET | `/api/todos/{id}` | id 하나로 Todo 조회 |
| Todo 생성 | POST | `/api/todos` | JSON으로 Todo 추가 |
| Todo 삭제 | DELETE | `/api/todos/{id}` | id 하나 삭제 |
| 완료 여부 검색 | GET | `/api/todos/search?completed=false` | 선택 실습 |

수업 중에는 **처음엔 H2**, 후반에는 **PostgreSQL**에서 같은 URL을 다시 호출합니다.

---

## 0. 오늘 알아야 할 단어는 딱 4개

| 단어 | 오늘 수업에서의 의미 |
|------|----------------------|
| Entity | Java 클래스와 DB 테이블을 연결한 것 |
| Repository | DB에 저장·조회·삭제하는 도구 |
| JPA | Java 객체를 DB에 넣고 빼게 해주는 표준 방식 |
| Profile | `h2`, `pg`처럼 실행 환경을 바꿔 끼우는 설정 |

예를 들면 이렇게 생각하면 됩니다.

```java
todoRepository.save(todo);
```

위 코드는 우리가 SQL을 직접 쓰지 않아도 내부적으로는 대략 이런 일을 합니다.

```sql
INSERT INTO todos (...) VALUES (...);
```

오늘은 SQL을 깊게 배우기보다, **Spring Boot가 JPA로 SQL을 만들어 주는 흐름**을 직접 봅니다.

---

## 전체 진행표

| 시간 | 실습 | 산출물 |
|------|------|--------|
| 0:00~0:15 | 프로젝트 준비 | JPA/H2/PostgreSQL 의존성 확인 |
| 0:15~0:35 | H2 프로필 설정 | H2 Console 접속 |
| 0:35~1:05 | Entity/Repository 작성 | `todos` 테이블 생성 |
| 1:05~1:45 | Service/Controller 작성 | CRUD API 동작 |
| 1:45~2:00 | Postman 검증 | H2에서 저장·조회 |
| 2:00~2:35 | PostgreSQL 전환 | `pg` 프로필 실행 |
| 2:35~2:55 | 같은 API 재검증 | PostgreSQL에 저장 |
| 2:55~3:00 | 과제 안내 | 제출 체크리스트 확인 |

---

## 실습 전 준비 체크리스트

수업을 시작하기 전에 아래를 확인합니다.

| 확인 항목 | 성공 기준 |
|-----------|-----------|
| JDK | 터미널에서 `java -version` 실행 가능 |
| 프로젝트 | IntelliJ에서 Spring Boot 프로젝트가 열림 |
| 백엔드 실행 | `./mvnw spring-boot:run` 또는 `mvnw.cmd spring-boot:run` 가능 |
| Postman | `GET http://localhost:8080` 요청을 보낼 수 있음 |
| PostgreSQL | 후반 실습 전까지 설치 또는 접속 준비 |

PostgreSQL이 아직 준비되지 않아도 초반 H2 실습은 그대로 진행할 수 있습니다.

---

## Lab 0. 프로젝트 준비

### 0-1. 기존 프로젝트를 쓸 때

4주차에 만든 Spring Boot 프로젝트가 있으면 그대로 사용해도 됩니다.

단, `pom.xml`에 아래 의존성이 있는지 확인합니다.

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>

<dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>runtime</scope>
</dependency>

<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

### 0-2. 새 프로젝트를 만들 때

[Spring Initializr](https://start.spring.io/)에서 아래처럼 선택합니다.

| 항목 | 선택 |
|------|------|
| Project | Maven |
| Language | Java |
| Spring Boot | 3.x |
| Group | `com.likelion` |
| Artifact | `todo-api` |
| Dependencies | Spring Web, Spring Data JPA, H2 Database, PostgreSQL Driver |

다운로드 후 압축을 풀고 IntelliJ에서 Open합니다.

### 0-3. 첫 실행 확인

```bash
./mvnw spring-boot:run
```

Windows:

```bash
mvnw.cmd spring-boot:run
```

`http://localhost:8080` 접속 시 404 페이지가 떠도 괜찮습니다. 아직 API를 만들지 않았다는 뜻입니다.

---

## Lab 1. H2와 PostgreSQL을 프로필로 나누기

오늘은 설정 파일을 세 개로 나눕니다.

```text
src/main/resources/
├── application.properties
├── application-h2.properties
└── application-pg.properties
```

### 1-1. 공통 설정: `application.properties`

```properties
spring.application.name=todo-db

# 개발 중에는 엔티티에 맞춰 테이블을 자동 생성/수정합니다.
spring.jpa.hibernate.ddl-auto=update

# 콘솔에 SQL을 보여줍니다.
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

# 수업에서는 화면 렌더링이 없으므로 false로 둡니다.
spring.jpa.open-in-view=false

# 처음에는 h2로 실행하고, 후반에 pg로 바꿉니다.
spring.profiles.active=h2
```

핵심은 마지막 줄입니다.

```properties
spring.profiles.active=h2
```

이 값이 `h2`이면 `application-h2.properties`가 붙고, `pg`이면 `application-pg.properties`가 붙습니다.

### 1-2. H2 설정: `application-h2.properties`

```properties
spring.datasource.url=jdbc:h2:file:~/likelion-todo;DB_CLOSE_DELAY=-1;AUTO_SERVER=TRUE
spring.datasource.username=sa
spring.datasource.password=
spring.datasource.driver-class-name=org.h2.Driver

spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
```

여기서는 메모리 DB가 아니라 **파일 DB**를 씁니다.

| 방식 | 특징 |
|------|------|
| `jdbc:h2:mem:testdb` | 서버 끄면 데이터 사라짐 |
| `jdbc:h2:file:~/likelion-todo` | 서버를 꺼도 파일에 저장됨 |

오늘은 “재시작해도 남는지” 확인해야 하므로 file 방식을 씁니다.

### 1-3. PostgreSQL 설정: `application-pg.properties`

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/tododb
spring.datasource.username=postgres
spring.datasource.password=YOUR_PASSWORD
spring.datasource.driver-class-name=org.postgresql.Driver

spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

`YOUR_PASSWORD`는 PostgreSQL 설치 시 정한 비밀번호로 나중에 바꿉니다.

---

## Lab 2. H2 Console 접속하기

서버를 실행합니다.

```bash
./mvnw spring-boot:run
```

브라우저에서 아래 주소로 접속합니다.

```text
http://localhost:8080/h2-console
```

입력값:

| 항목 | 값 |
|------|----|
| JDBC URL | `jdbc:h2:file:~/likelion-todo` |
| User Name | `sa` |
| Password | 비워두기 |

주의할 점은 **JDBC URL이 설정 파일과 완전히 같아야 한다**는 것입니다.

처음에는 테이블이 없어도 정상입니다. 다음 실습에서 `Todo` 엔티티를 만들면 테이블이 생깁니다.

---

## Lab 3. Todo 엔티티 만들기

패키지 예시:

```text
src/main/java/com/likelion/todoapi/domain/Todo.java
```

프로젝트 패키지 이름이 다르면 `package` 줄만 본인 프로젝트에 맞게 바꿉니다.

```java
package com.likelion.todoapi.domain;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "todos")
public class Todo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(length = 1000)
    private String description;

    private boolean completed;

    private LocalDateTime createdAt;

    protected Todo() {
    }

    public Todo(String title, String description) {
        this.title = title;
        this.description = description;
        this.completed = false;
        this.createdAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
```

### 코드 설명

| 코드 | 의미 |
|------|------|
| `@Entity` | 이 클래스를 DB 테이블과 연결 |
| `@Table(name = "todos")` | 테이블 이름을 `todos`로 지정 |
| `@Id` | 기본키 |
| `@GeneratedValue` | id 자동 증가 |
| `@Column(nullable = false)` | DB 컬럼 제약조건 |
| `protected Todo()` | JPA가 객체를 만들 때 필요 |

### 확인

서버 재시작 후 H2 Console에서 `TODOS` 테이블이 보이면 성공입니다.

---

## Lab 4. Repository 만들기

파일:

```text
src/main/java/com/likelion/todoapi/domain/TodoRepository.java
```

```java
package com.likelion.todoapi.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TodoRepository extends JpaRepository<Todo, Long> {

    List<Todo> findByCompleted(boolean completed);

    List<Todo> findByTitleContainingIgnoreCase(String keyword);
}
```

### 왜 인터페이스만 만들까?

`JpaRepository<Todo, Long>` 안에 기본 기능이 이미 들어 있습니다.

| 메서드 | 역할 |
|--------|------|
| `findAll()` | 전체 조회 |
| `findById(id)` | id로 단건 조회 |
| `save(todo)` | 저장 또는 수정 |
| `deleteById(id)` | id로 삭제 |
| `count()` | 개수 조회 |

우리는 여기에 필요한 검색 규칙만 추가합니다.

```java
List<Todo> findByCompleted(boolean completed);
```

Spring Data JPA는 이 메서드 이름을 보고 이런 의미로 해석합니다.

```sql
SELECT * FROM todos WHERE completed = ?;
```

---

## Lab 5. Service 만들기

파일:

```text
src/main/java/com/likelion/todoapi/service/TodoService.java
```

```java
package com.likelion.todoapi.service;

import com.likelion.todoapi.domain.Todo;
import com.likelion.todoapi.domain.TodoRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TodoService {

    private final TodoRepository todoRepository;

    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    public List<Todo> getAll() {
        return todoRepository.findAll();
    }

    public Todo get(Long id) {
        return todoRepository.findById(id).orElseThrow();
    }

    @Transactional
    public Todo create(String title, String description) {
        Todo todo = new Todo(title, description);
        return todoRepository.save(todo);
    }

    @Transactional
    public Todo toggleCompleted(Long id) {
        Todo todo = todoRepository.findById(id).orElseThrow();
        todo.setCompleted(!todo.isCompleted());
        return todo;
    }

    @Transactional
    public void delete(Long id) {
        todoRepository.deleteById(id);
    }

    public List<Todo> getByCompleted(boolean completed) {
        return todoRepository.findByCompleted(completed);
    }

    public List<Todo> searchByTitle(String keyword) {
        return todoRepository.findByTitleContainingIgnoreCase(keyword);
    }
}
```

### 여기서 중요한 점

- `create`, `toggleCompleted`, `delete`처럼 DB를 바꾸는 메서드에는 `@Transactional`을 붙입니다.
- `toggleCompleted`는 `save()`를 다시 호출하지 않아도 됩니다. 트랜잭션 안에서 가져온 객체를 바꾸면 JPA가 변경을 감지합니다.
- 지금은 쉬운 수업을 위해 `orElseThrow()`만 썼습니다. 예외 메시지를 예쁘게 만드는 것은 다음 단계입니다.

---

## Lab 6. Controller 만들기

파일:

```text
src/main/java/com/likelion/todoapi/controller/TodoController.java
```

```java
package com.likelion.todoapi.controller;

import com.likelion.todoapi.domain.Todo;
import com.likelion.todoapi.service.TodoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/todos")
public class TodoController {

    private final TodoService todoService;

    public TodoController(TodoService todoService) {
        this.todoService = todoService;
    }

    @GetMapping
    public List<Todo> list() {
        return todoService.getAll();
    }

    @GetMapping("/{id}")
    public Todo one(@PathVariable Long id) {
        return todoService.get(id);
    }

    @PostMapping
    public ResponseEntity<Todo> create(@RequestBody Map<String, String> body) {
        String title = body.getOrDefault("title", "").trim();
        String description = body.getOrDefault("description", "");

        if (title.isBlank()) {
            return ResponseEntity.badRequest().build();
        }

        Todo saved = todoService.create(title, description);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @PatchMapping("/{id}/toggle")
    public Todo toggle(@PathVariable Long id) {
        return todoService.toggleCompleted(id);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> remove(@PathVariable Long id) {
        todoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/search")
    public List<Todo> search(
        @RequestParam(required = false) Boolean completed,
        @RequestParam(required = false) String keyword
    ) {
        if (completed != null) {
            return todoService.getByCompleted(completed);
        }

        if (keyword != null && !keyword.isBlank()) {
            return todoService.searchByTitle(keyword);
        }

        return todoService.getAll();
    }
}
```

### URL 정리

| 기능 | 요청 |
|------|------|
| 전체 조회 | `GET /api/todos` |
| 단건 조회 | `GET /api/todos/1` |
| 생성 | `POST /api/todos` |
| 완료 토글 | `PATCH /api/todos/1/toggle` |
| 삭제 | `DELETE /api/todos/1` |
| 완료 여부 검색 | `GET /api/todos/search?completed=false` |
| 제목 검색 | `GET /api/todos/search?keyword=공부` |

---

## Lab 7. Postman으로 H2 검증하기

### 7-1. 목록 조회

```http
GET http://localhost:8080/api/todos
```

처음에는 빈 배열이 정상입니다.

```json
[]
```

### 7-2. Todo 생성

```http
POST http://localhost:8080/api/todos
Content-Type: application/json
```

Body:

```json
{
  "title": "JPA 실습하기",
  "description": "H2에 먼저 저장해보기"
}
```

응답 예시:

```json
{
  "id": 1,
  "title": "JPA 실습하기",
  "description": "H2에 먼저 저장해보기",
  "completed": false,
  "createdAt": "2026-05-18T09:00:00"
}
```

### 7-3. 서버 재시작 후 확인

1. 서버 종료
2. 다시 실행
3. `GET /api/todos`

방금 넣은 데이터가 그대로 있으면 H2 파일 DB 성공입니다.

---

## Lab 8. PostgreSQL 설치와 DB 생성

### 8-1. 설치 선택지

| OS | 추천 |
|----|------|
| Windows | PostgreSQL 공식 Installer + pgAdmin |
| macOS | Postgres.app 또는 Homebrew |

공식 다운로드: [postgresql.org/download](https://www.postgresql.org/download/)

### 8-2. DB 생성

pgAdmin 또는 터미널에서 아래 SQL을 한 번 실행합니다.

```sql
CREATE DATABASE tododb;
```

이미 있으면 이런 에러가 날 수 있습니다.

```text
database "tododb" already exists
```

그 경우는 넘어가도 됩니다.

### 8-3. PostgreSQL 설정 수정

`application-pg.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/tododb
spring.datasource.username=postgres
spring.datasource.password=설치할때정한비밀번호
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

비밀번호를 GitHub에 올리지 않도록 주의합니다.

---

## Lab 9. H2에서 PostgreSQL로 전환하기

`application.properties`에서 한 줄만 바꿉니다.

```properties
spring.profiles.active=pg
```

서버 재실행:

```bash
./mvnw spring-boot:run
```

### 자주 나는 에러

| 에러 상황 | 원인 |
|----------|------|
| `Connection refused` | PostgreSQL 서버가 꺼져 있음 |
| `password authentication failed` | 비밀번호 오타 |
| `database "tododb" does not exist` | DB 생성 안 함 |
| `port 5432` 관련 에러 | 포트가 다르거나 이미 다른 DB 사용 중 |

### 중요한 점

H2에 넣어 둔 데이터가 PostgreSQL로 자동 복사되지는 않습니다.

PostgreSQL로 전환한 뒤에는 Postman으로 다시 POST해서 데이터를 넣고 확인합니다.

---

## Lab 10. PostgreSQL 상태에서 같은 API 검증

아래 순서로 다시 확인합니다.

1. `GET /api/todos`
2. `POST /api/todos`
3. `GET /api/todos`
4. `PATCH /api/todos/{id}/toggle`
5. `GET /api/todos/search?completed=true`
6. `DELETE /api/todos/{id}`

여기서 중요한 건 **URL이 H2 때와 똑같다**는 점입니다.

바뀐 것은 Java 코드가 아니라 실행 프로필입니다.

```properties
spring.profiles.active=pg
```

---

## Lab 11. 오늘 수업에서 꼭 기억할 것

1. `@Entity`를 만들면 테이블과 연결된다.
2. `JpaRepository`를 상속하면 기본 CRUD가 생긴다.
3. H2는 빠른 연습용으로 좋다.
4. PostgreSQL은 실제 서비스와 더 가까운 DB다.
5. Spring Profile을 쓰면 같은 코드로 DB를 바꿔 끼울 수 있다.

---

## 과제 안내

`exercises.md`의 순서대로 제출합니다.

- 1단계: H2에서 Todo API 동작 + 재시작 후 데이터 유지 증명
- 2단계: PostgreSQL로 전환 후 같은 API 동작 증명
- 3단계 이후: 검색, `@Query`, 관계 매핑 등 추가 실습

다음 주에는 이 API를 React 화면에서 호출합니다.
