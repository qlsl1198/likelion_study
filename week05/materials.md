# 5주차 보조 자료 (복붙용 치트시트)

교안 순서는 **`presentation.md`** Lab 번호이다. 여기에는 **설정 세트 + 전체 클래스**를 길게 둔다.

---

## Maven 의존성 (Starter에 빠졌을 때만)

```xml
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

## 프로필 3종 (한 세트 그대로 복사)

**`application.properties`**

```properties
spring.application.name=todo-db
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.open-in-view=false

# 수업 순서: 먼저 h2 → Lab 6 이후 pg
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

**`application-pg.properties`**

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/tododb
spring.datasource.username=postgres
spring.datasource.password=여기실제비번
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

PostgreSQL 전환 요약:

1. `CREATE DATABASE tododb;`
2. 위 비번 수정
3. `spring.profiles.active=pg` 로 변경 후 재실행

다시 H2만 쓰려면 → `spring.profiles.active=h2`.

---

## `Todo.java` 전체 예시

`package` 는 본인 프로젝트에 맞출 것.

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

    protected Todo() {}

    public Todo(String title, String description) {
        this.title = title;
        this.description = description;
        this.completed = false;
        this.createdAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
```

---

## `TodoRepository.java`

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

## `TodoService.java`

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

    @Transactional
    public Todo create(String title, String description) {
        return todoRepository.save(new Todo(title, description));
    }

    public Todo get(Long id) {
        return todoRepository.findById(id).orElseThrow();
    }

    @Transactional
    public void delete(Long id) {
        todoRepository.deleteById(id);
    }

    public List<Todo> getByCompleted(boolean done) {
        return todoRepository.findByCompleted(done);
    }
}
```

---

## `TodoController.java`

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

    @PostMapping
    public ResponseEntity<Todo> create(@RequestBody Map<String, String> body) {
        String title = body.getOrDefault("title", "제목없음");
        String description = body.getOrDefault("description", "");
        Todo saved = todoService.create(title, description);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping("/{id}")
    public Todo one(@PathVariable Long id) {
        return todoService.get(id);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> remove(@PathVariable Long id) {
        todoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/search")
    public List<Todo> byCompleted(@RequestParam boolean completed) {
        return todoService.getByCompleted(completed);
    }
}
```

---

## PostgreSQL 만들기 한 줄

```sql
CREATE DATABASE tododb;
```

---

## 자주 나는 문제

| 증상 | 점검 |
|------|------|
| H2 Console 연결 불가 | JDBC URL 과 `properties` 문자열 동일 여부 |
| pg 전환 후 기동 실패 | 비번·포트 5432·DB 이름 오타 |
| 빈 실행은 되는데 API 404 | `@SpringBootApplication` 패키지와 Controller 패키지 위치 |
| 8080 충돌 | `server.port=8081` |

---

## 심화만 참고 (공식 문서)

- [Spring Data JPA — Query methods](https://docs.spring.io/spring-data/jpa/reference/jpa/query-methods.html)
