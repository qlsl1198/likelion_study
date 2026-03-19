# 4주차 보조 자료

## application.properties 설정

### 기본 설정
```properties
# 서버 포트
server.port=8080

# 애플리케이션 이름
spring.application.name=todo-api

# 로깅 레벨
logging.level.root=INFO
logging.level.com.likelion=DEBUG
```

### 데이터베이스 설정 (PostgreSQL)
```properties
# 데이터소스 설정
spring.datasource.url=jdbc:postgresql://localhost:5432/tododb
spring.datasource.username=postgres
spring.datasource.password=yourpassword
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA 설정
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

### 데이터베이스 설정 (H2 - 개발용)
```properties
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driver-class-name=org.h2.Driver
spring.h2.console.enabled=true
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
```

## 어노테이션 정리

### 클래스 레벨 어노테이션
- `@RestController`: REST 컨트롤러 (JSON 응답)
- `@Controller`: MVC 컨트롤러 (View 반환)
- `@Service`: 서비스 계층
- `@Repository`: 리포지토리 계층
- `@Component`: 일반 컴포넌트
- `@Entity`: JPA 엔티티
- `@Configuration`: 설정 클래스

### 메서드 레벨 어노테이션
- `@GetMapping`: GET 요청 매핑
- `@PostMapping`: POST 요청 매핑
- `@PutMapping`: PUT 요청 매핑
- `@PatchMapping`: PATCH 요청 매핑
- `@DeleteMapping`: DELETE 요청 매핑
- `@RequestMapping`: 범용 요청 매핑

### 매개변수 어노테이션
- `@PathVariable`: URL 경로 변수
- `@RequestParam`: 쿼리 파라미터
- `@RequestBody`: 요청 본문
- `@RequestHeader`: HTTP 헤더

## ResponseEntity 사용

### 상태 코드 지정
```java
@PostMapping("/todos")
public ResponseEntity<Todo> createTodo(@RequestBody Todo todo) {
    Todo created = todoService.createTodo(todo);
    return ResponseEntity.status(HttpStatus.CREATED).body(created);
}

@GetMapping("/todos/{id}")
public ResponseEntity<Todo> getTodo(@PathVariable Long id) {
    Todo todo = todoService.getTodoById(id);
    return ResponseEntity.ok(todo);
}

@DeleteMapping("/todos/{id}")
public ResponseEntity<Void> deleteTodo(@PathVariable Long id) {
    todoService.deleteTodo(id);
    return ResponseEntity.noContent().build();
}
```

## 의존성 주입 (Dependency Injection)

### 생성자 주입 (권장)
```java
@Service
public class TodoService {
    private final TodoRepository todoRepository;
    
    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }
}
```

### 필드 주입 (비권장)
```java
@Service
public class TodoService {
    @Autowired
    private TodoRepository todoRepository;
}
```

### Setter 주입 (비권장)
```java
@Service
public class TodoService {
    private TodoRepository todoRepository;
    
    @Autowired
    public void setTodoRepository(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }
}
```

## CORS 설정

### 전역 CORS 설정
```java
@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**")
                    .allowedOrigins("http://localhost:3000")
                    .allowedMethods("GET", "POST", "PUT", "DELETE")
                    .allowedHeaders("*");
            }
        };
    }
}
```

### 컨트롤러 레벨 CORS 설정
```java
@CrossOrigin(origins = "http://localhost:3000")
@RestController
public class TodoController {
    // ...
}
```

## 로깅

### Logger 사용
```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
public class TodoController {
    private static final Logger logger = LoggerFactory.getLogger(TodoController.class);
    
    @GetMapping("/todos")
    public List<Todo> getTodos() {
        logger.info("Getting all todos");
        logger.debug("Debug message");
        logger.error("Error message");
        return todoService.getAllTodos();
    }
}
```

## 유효성 검증 (Validation)

### 의존성 추가 (pom.xml)
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

### DTO에 검증 어노테이션 추가
```java
public class TodoRequestDTO {
    @NotBlank(message = "Title is required")
    @Size(min = 1, max = 100, message = "Title must be between 1 and 100 characters")
    private String title;
    
    @Email(message = "Email should be valid")
    private String email;
    
    @Min(value = 0, message = "Age must be positive")
    private int age;
}
```

### 컨트롤러에서 검증
```java
@PostMapping("/todos")
public ResponseEntity<Todo> createTodo(
    @Valid @RequestBody TodoRequestDTO requestDTO
) {
    // 검증 실패 시 자동으로 400 Bad Request 반환
    Todo todo = todoService.createTodo(requestDTO);
    return ResponseEntity.status(HttpStatus.CREATED).body(todo);
}
```

## 테스트 작성

### 컨트롤러 테스트
```java
@SpringBootTest
@AutoConfigureMockMvc
class TodoControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @Test
    void getAllTodos() throws Exception {
        mockMvc.perform(get("/api/todos"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$").isArray());
    }
}
```

