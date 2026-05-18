# 5주차 보조 자료 — H2 → PostgreSQL DB 연동 치트시트

이 파일은 수업 중 막혔을 때 빠르게 복사하거나 확인하는 자료입니다. 강의 흐름은 `presentation.md`를 기준으로 합니다.

---

## 0. 처음부터 끝까지 타이핑 순서

아래 순서만 지키면 됩니다.

1. `pom.xml` 의존성 확인
2. `application.properties` 작성
3. `application-h2.properties` 작성
4. `application-pg.properties` 작성
5. 서버 실행 후 H2 Console 접속
6. `domain/Todo.java` 작성
7. 서버 재실행 후 H2 Console에서 테이블 확인
8. `domain/TodoRepository.java` 작성
9. `service/TodoService.java` 작성
10. `controller/TodoController.java` 작성
11. Postman으로 H2에서 `GET`, `POST`, `PATCH`, `DELETE` 확인
12. 서버 재시작 후 데이터 유지 확인
13. PostgreSQL에 `tododb` 생성
14. `spring.profiles.active=pg`로 변경
15. Postman으로 같은 API 재확인

### 멈춰야 하는 기준

아래 중 하나라도 실패하면 다음 단계로 넘어가지 않습니다.

- 서버가 실행되지 않음
- H2 Console에 접속되지 않음
- `TODOS` 테이블이 생성되지 않음
- Postman `POST /api/todos`가 실패함
- PostgreSQL 전환 후 서버가 실행되지 않음

---

## 1. 프로젝트 의존성

Spring Initializr에서 넣으면 `pom.xml`에 자동으로 들어갑니다. 빠졌다면 아래 의존성을 추가합니다.

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

---

## 2. 설정 파일 세트

### `application.properties`

```properties
spring.application.name=todo-db

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.open-in-view=false

spring.profiles.active=h2
```

### `application-h2.properties`

```properties
spring.datasource.url=jdbc:h2:file:~/likelion-todo;DB_CLOSE_DELAY=-1;AUTO_SERVER=TRUE
spring.datasource.username=sa
spring.datasource.password=
spring.datasource.driver-class-name=org.h2.Driver

spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
```

### `application-pg.properties`

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/tododb
spring.datasource.username=postgres
spring.datasource.password=여기실제비밀번호
spring.datasource.driver-class-name=org.postgresql.Driver

spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

### 프로필 전환

```properties
spring.profiles.active=h2
```

또는

```properties
spring.profiles.active=pg
```

---

## 3. 파일 구조 예시

```text
src/main/java/com/likelion/todoapi/
├── TodoApiApplication.java
├── controller/
│   └── TodoController.java
├── domain/
│   ├── Todo.java
│   └── TodoRepository.java
└── service/
    └── TodoService.java

src/main/resources/
├── application.properties
├── application-h2.properties
└── application-pg.properties
```

패키지명은 본인 프로젝트에 맞춥니다. 중요한 것은 `TodoApiApplication` 아래 하위 패키지에 controller/domain/service가 있어야 자동 스캔된다는 점입니다.

---

## 4. `Todo.java`

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

---

## 5. `TodoRepository.java`

```java
package com.likelion.todoapi.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TodoRepository extends JpaRepository<Todo, Long> {

    List<Todo> findByCompleted(boolean completed);

    List<Todo> findByTitleContainingIgnoreCase(String keyword);
}
```

---

## 6. `TodoService.java`

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

---

## 7. `TodoController.java`

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

---

## 8. Postman 요청 모음

### 전체 조회

```http
GET http://localhost:8080/api/todos
```

### 생성

```http
POST http://localhost:8080/api/todos
Content-Type: application/json
```

```json
{
  "title": "JPA 실습하기",
  "description": "H2에서 PostgreSQL까지 연결"
}
```

성공 기준:

- Status: `201 Created`
- Response Body에 `id`가 생김
- `completed` 값이 `false`

### 단건 조회

```http
GET http://localhost:8080/api/todos/1
```

### 완료 토글

```http
PATCH http://localhost:8080/api/todos/1/toggle
```

### 완료 여부 검색

```http
GET http://localhost:8080/api/todos/search?completed=true
```

```http
GET http://localhost:8080/api/todos/search?completed=false
```

### 제목 검색

```http
GET http://localhost:8080/api/todos/search?keyword=JPA
```

### 삭제

```http
DELETE http://localhost:8080/api/todos/1
```

성공 기준:

- Status: `204 No Content`
- 다시 `GET /api/todos/1` 했을 때 조회되지 않거나 에러가 남

---

## 9. PostgreSQL 명령

### DB 생성

```sql
CREATE DATABASE tododb;
```

### psql 접속 예시

macOS/Homebrew 환경 예시:

```bash
psql postgres
```

비밀번호 사용자 접속 예시:

```bash
psql -U postgres
```

### 테이블 확인 예시

```sql
\c tododb
\dt
select * from todos;
```

---

## 10. 오류 대응표

| 증상 | 확인할 것 |
|------|-----------|
| H2 Console 접속 실패 | JDBC URL이 `jdbc:h2:file:~/likelion-todo`와 같은지 |
| 테이블이 안 생김 | `@Entity`가 붙었는지, 패키지 스캔 범위 안인지 |
| `No qualifying bean` | Repository/Service 패키지가 앱 루트 밖인지 |
| `Connection refused` | PostgreSQL 서버가 실행 중인지 |
| `password authentication failed` | `application-pg.properties` 비밀번호 오타 |
| `database "tododb" does not exist` | `CREATE DATABASE tododb;` 실행 여부 |
| `Port 8080 already in use` | 기존 서버 종료 또는 `server.port=8081` |

### 에러 질문 템플릿

질문할 때 아래처럼 적으면 바로 도와주기 쉽습니다.

```text
몇 단계: 예) H2 Console 접속
실행한 명령: ./mvnw spring-boot:run
기대한 결과: H2 Console Connect 성공
실제 결과: Database not found
터미널 마지막 20줄:
...
```

---

## 11. 제출 전 체크

- H2 상태에서 POST/GET 캡처
- H2 서버 재시작 후 데이터 유지 캡처 또는 설명
- `pg` 프로필로 전환한 상태에서 POST/GET 캡처
- 실제 DB 비밀번호가 GitHub에 올라가지 않았는지 확인

---

## 12. 더 해보고 싶은 사람

### `@Query` 예시

```java
@Query("select t from Todo t where t.completed = false order by t.createdAt desc")
List<Todo> findLatestUncompletedTodos();
```

### BaseEntity 아이디어

`createdAt`, `updatedAt`을 여러 엔티티가 공유할 때 부모 클래스로 뺄 수 있습니다.

```java
@MappedSuperclass
public abstract class BaseEntity {
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
```
