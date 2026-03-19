# 4주차: Spring Boot 기초

## 📋 학습 목표
- Spring Boot의 개념과 장점을 이해한다
- Spring Boot 프로젝트를 생성하고 실행할 수 있다
- Spring MVC 패턴을 이해한다
- RESTful API를 설계하고 구현할 수 있다
- 컨트롤러, 서비스, 리포지토리 계층을 이해한다

---

## 💡 비전공자를 위한 한눈에 보기

- **Spring Boot**: Java로 웹 서버(백엔드)를 빠르게 만드는 도구. 설정을 많이 자동으로 해줌
- **MVC**: Model(데이터) · View(보여주기) · Controller(요청 처리)를 나눠서 만드는 방식. 역할 분리로 관리가 쉬워짐
- **REST API**: "URL + HTTP 메서드"로 데이터를 주고받는 규칙. GET=조회, POST=생성, PUT=수정, DELETE=삭제
- **DTO**: 클라이언트와 주고받을 데이터를 담는 "상자". 실제 DB 구조를 그대로 노출하지 않고, 필요한 필드만 포함

---

## 1. Spring Boot 소개 (30분)

### 1.1 Spring Boot란?
- **정의**: Spring Framework 기반의 프로덕션 준비가 된 애플리케이션을 빠르게 만들 수 있게 해주는 프레임워크
- **특징**:
  - 자동 설정 (Auto Configuration)
  - 내장 서버 (Tomcat, Jetty)
  - 프로덕션 준비 기능
  - 의존성 관리

### 1.2 Spring Boot의 장점
- **빠른 개발**: 복잡한 설정 없이 바로 시작
- **내장 서버**: 별도 서버 설치 불필요
- **자동 설정**: 최소한의 설정으로 동작
- **프로덕션 준비**: 모니터링, 메트릭 등 제공

### 1.3 Spring Boot vs Spring Framework
- Spring Framework: 유연하지만 설정이 복잡
- Spring Boot: 설정이 간단하고 빠른 개발 가능

---

## 2. Spring Boot 프로젝트 생성 (30분)

### 2.1 Spring Initializr 사용 - 따라하기

**💡 Spring Initializr란?** 웹에서 클릭만으로 Spring Boot 프로젝트 뼈대를 만들어 주는 도구. 복잡한 설정 없이 "의존성 선택"만 하면 됨.

| 단계 | 작업 | 설명 |
|------|------|------|
| 1 | https://start.spring.io/ 접속 | 브라우저에서 열기 |
| 2 | Project: **Maven** 선택 | 빌드 도구 (Gradle도 가능) |
| 3 | Language: **Java** | |
| 4 | Spring Boot: **3.x** (최신 안정) | 드롭다운에서 선택 |
| 5 | Group: `com.likelion` | 패키지 상위 경로 |
| 6 | Artifact: `todo-api` | 프로젝트 이름 (소문자, 하이픈 사용) |
| 7 | Add Dependencies 클릭 | Spring Web, Spring Data JPA, PostgreSQL Driver 선택 |
| 8 | **Generate** 클릭 | ZIP 파일 다운로드됨 |
| 9 | ZIP 압축 해제 → IntelliJ에서 **Open** | File → Open → 압축 푼 폴더 선택 |

**의존성 설명 (비전공자용)**:
- **Spring Web**: REST API, HTTP 요청 처리
- **Spring Data JPA**: DB를 객체처럼 다루는 도구
- **PostgreSQL Driver**: PostgreSQL DB와 연결하는 드라이버

### 2.2 프로젝트 구조
```
todo-api/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/likelion/todoapi/
│   │   │       └── TodoApiApplication.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
├── pom.xml (Maven)
└── README.md
```

### 2.3 첫 번째 애플리케이션 실행
```java
@SpringBootApplication
public class TodoApiApplication {
    public static void main(String[] args) {
        SpringApplication.run(TodoApiApplication.class, args);
    }
}
```

```bash
# Maven 사용 (터미널에서 프로젝트 폴더 안에서)
./mvnw spring-boot:run

# Windows: mvnw.cmd 사용
# 또는 IntelliJ: 우클릭 TodoApiApplication.java → Run
```

**실행 확인**: 브라우저에서 `http://localhost:8080` 접속. (아직 API가 없으면 404 에러가 나도 서버가 떴다는 의미)

### 2.4 Postman 설치 (API 테스트용) - 따라하기

API를 테스트할 때 브라우저는 GET만 편하게 쓰고, POST/PUT/DELETE 등을 보내려면 도구가 필요함. Postman이 그 도구.

| 단계 | 작업 |
|------|------|
| 1 | https://www.postman.com/downloads/ 접속 |
| 2 | OS에 맞는 버전 다운로드 → 설치 |
| 3 | 회원가입 또는 "Skip and go to the app" |
| 4 | New → HTTP Request 생성 |
| 5 | Method(GET/POST 등), URL 입력 후 Send |

**간단 사용법**:
- GET: URL만 입력 후 Send
- POST: Body → raw → JSON 선택 후 `{"title":"테스트","completed":false}` 입력

---

## 3. Spring MVC 패턴 (60분)

### 3.1 MVC 패턴이란?
- **Model**: 데이터와 비즈니스 로직
  - 데이터의 구조, 검증, 비즈니스 규칙을 담당
  - 데이터베이스와의 상호작용 로직 포함
- **View**: 사용자 인터페이스 (REST API에서는 JSON 응답)
  - 클라이언트에게 보여줄 데이터의 표현 담당
  - 웹 API에서는 데이터를 JSON 형식으로 변환하여 전달
- **Controller**: 요청 처리 및 응답 반환
  - 클라이언트 요청을 받아 Model과 View 사이를 연결
  - URL 라우팅, 요청 검증, 예외 처리 담당

- **왜 계층을 분리하나요?**
  - **관심사 분리**: 각 계층이 한 가지 역할만 담당해 유지보수가 쉬움
  - **재사용성**: 서비스 로직을 다른 컨트롤러에서도 사용 가능
  - **테스트 용이**: 각 계층을 독립적으로 테스트 가능

### 3.2 계층 구조
```
Controller (컨트롤러)
    ↓
Service (서비스)
    ↓
Repository (리포지토리)
    ↓
Database (데이터베이스)
```

### 3.3 Controller 계층
```java
@RestController
@RequestMapping("/api/todos")
public class TodoController {
    
    private final TodoService todoService;
    
    // 생성자 주입
    public TodoController(TodoService todoService) {
        this.todoService = todoService;
    }
    
    @GetMapping
    public List<Todo> getAllTodos() {
        return todoService.getAllTodos();
    }
    
    @GetMapping("/{id}")
    public Todo getTodo(@PathVariable Long id) {
        return todoService.getTodoById(id);
    }
    
    @PostMapping
    public Todo createTodo(@RequestBody Todo todo) {
        return todoService.createTodo(todo);
    }
    
    @PutMapping("/{id}")
    public Todo updateTodo(@PathVariable Long id, @RequestBody Todo todo) {
        return todoService.updateTodo(id, todo);
    }
    
    @DeleteMapping("/{id}")
    public void deleteTodo(@PathVariable Long id) {
        todoService.deleteTodo(id);
    }
}
```

### 3.4 Service 계층
```java
@Service
public class TodoService {
    
    private final TodoRepository todoRepository;
    
    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }
    
    public List<Todo> getAllTodos() {
        return todoRepository.findAll();
    }
    
    public Todo getTodoById(Long id) {
        return todoRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Todo not found"));
    }
    
    public Todo createTodo(Todo todo) {
        return todoRepository.save(todo);
    }
    
    public Todo updateTodo(Long id, Todo todo) {
        Todo existingTodo = getTodoById(id);
        existingTodo.setTitle(todo.getTitle());
        existingTodo.setCompleted(todo.isCompleted());
        return todoRepository.save(existingTodo);
    }
    
    public void deleteTodo(Long id) {
        todoRepository.deleteById(id);
    }
}
```

### 3.5 Repository 계층
```java
public interface TodoRepository extends JpaRepository<Todo, Long> {
    // 기본 CRUD 메서드는 JpaRepository에서 제공
    // 커스텀 메서드 추가 가능
    List<Todo> findByCompleted(boolean completed);
}
```

---

## 4. RESTful API 설계 (90분)

### 4.1 REST란?
- **정의**: Representational State Transfer
  - 웹의 장점을 활용해 API를 설계하기 위한 아키텍처 스타일
  - 리소스(데이터)를 URI로 표현하고, HTTP 메서드로 조작
- **원칙**:
  - **리소스 기반 URL**: `/api/todos`, `/api/users/1`처럼 명사로 표현
  - **HTTP 메서드 사용**: GET(조회), POST(생성), PUT(수정), DELETE(삭제)
  - **Stateless (상태 없음)**: 서버가 클라이언트의 이전 요청을 기억하지 않음
    - 각 요청은 독립적이며, 필요한 모든 정보가 요청에 포함됨
    - 서버 확장이 용이하고, 세션 저장소가 불필요
  - **JSON/XML 형식**: 표준화된 데이터 포맷으로 교환

### 4.2 HTTP 메서드
- **GET**: 리소스 조회
- **POST**: 리소스 생성
- **PUT**: 리소스 전체 수정
- **PATCH**: 리소스 부분 수정
- **DELETE**: 리소스 삭제

### 4.3 RESTful API 설계 예시
```
GET    /api/todos          → 모든 Todo 조회
GET    /api/todos/{id}     → 특정 Todo 조회
POST   /api/todos          → Todo 생성
PUT    /api/todos/{id}     → Todo 수정
DELETE /api/todos/{id}     → Todo 삭제
```

### 4.4 @RestController vs @Controller
```java
// @RestController: JSON 응답 자동 변환
@RestController
public class TodoController {
    @GetMapping("/todos")
    public List<Todo> getTodos() {
        return todos;  // 자동으로 JSON 변환
    }
}

// @Controller: View 반환 (템플릿)
@Controller
public class TodoController {
    @GetMapping("/todos")
    public String getTodos(Model model) {
        model.addAttribute("todos", todos);
        return "todos";  // templates/todos.html
    }
}
```

### 4.5 요청 매핑 어노테이션
```java
@RestController
@RequestMapping("/api/todos")  // 기본 경로
public class TodoController {
    
    @GetMapping                    // GET /api/todos
    public List<Todo> getAll() { }
    
    @GetMapping("/{id}")          // GET /api/todos/{id}
    public Todo getOne(@PathVariable Long id) { }
    
    @PostMapping                  // POST /api/todos
    public Todo create(@RequestBody Todo todo) { }
    
    @PutMapping("/{id}")         // PUT /api/todos/{id}
    public Todo update(@PathVariable Long id, @RequestBody Todo todo) { }
    
    @DeleteMapping("/{id}")      // DELETE /api/todos/{id}
    public void delete(@PathVariable Long id) { }
}
```

### 4.6 요청/응답 처리
```java
@RestController
public class TodoController {
    
    // @RequestBody: 요청 본문을 객체로 변환
    @PostMapping("/todos")
    public Todo create(@RequestBody Todo todo) {
        return todoService.create(todo);
    }
    
    // @PathVariable: URL 경로 변수
    @GetMapping("/todos/{id}")
    public Todo getTodo(@PathVariable Long id) {
        return todoService.getTodoById(id);
    }
    
    // @RequestParam: 쿼리 파라미터
    @GetMapping("/todos")
    public List<Todo> getTodos(
        @RequestParam(required = false) Boolean completed
    ) {
        if (completed != null) {
            return todoService.getTodosByCompleted(completed);
        }
        return todoService.getAllTodos();
    }
}
```

---

## 5. DTO (Data Transfer Object) (60분)

### 5.1 DTO란?
- **정의**: Data Transfer Object - 계층 간 데이터 전송을 위한 객체
- **왜 Entity 대신 DTO를 사용하나요?**
  - **엔티티 노출 방지**: JPA 엔티티에는 ID, 연관관계 등 내부 구현이 담겨 있어 API 응답으로 그대로 노출하면 보안·구조상 위험
  - **필요한 데이터만 전송**: 클라이언트에 필요한 필드만 선별해 전달 (예: 비밀번호 제외)
  - **검증 로직 추가**: `@Valid`, `@NotBlank` 등으로 요청 데이터 검증
  - **API 버전 관리**: 응답 형식 변경 시 엔티티 수정 없이 DTO만 변경 가능

### 5.2 DTO 생성
```java
// TodoRequestDTO.java
public class TodoRequestDTO {
    private String title;
    private String description;
    private boolean completed;
    
    // 생성자, getter, setter
    public TodoRequestDTO() {}
    
    public TodoRequestDTO(String title, String description, boolean completed) {
        this.title = title;
        this.description = description;
        this.completed = completed;
    }
    
    // getters and setters
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    // ...
}

// TodoResponseDTO.java
public class TodoResponseDTO {
    private Long id;
    private String title;
    private String description;
    private boolean completed;
    private LocalDateTime createdAt;
    
    // 생성자, getter, setter
}
```

### 5.3 DTO 사용
```java
@RestController
@RequestMapping("/api/todos")
public class TodoController {
    
    private final TodoService todoService;
    
    @PostMapping
    public ResponseEntity<TodoResponseDTO> createTodo(
        @RequestBody TodoRequestDTO requestDTO
    ) {
        Todo todo = todoService.createTodo(requestDTO);
        TodoResponseDTO responseDTO = convertToDTO(todo);
        return ResponseEntity.status(HttpStatus.CREATED).body(responseDTO);
    }
    
    private TodoResponseDTO convertToDTO(Todo todo) {
        TodoResponseDTO dto = new TodoResponseDTO();
        dto.setId(todo.getId());
        dto.setTitle(todo.getTitle());
        dto.setDescription(todo.getDescription());
        dto.setCompleted(todo.isCompleted());
        dto.setCreatedAt(todo.getCreatedAt());
        return dto;
    }
}
```

---

## 6. 예외 처리 (30분)

### 6.1 기본 예외 처리
```java
@RestController
@RequestMapping("/api/todos")
public class TodoController {
    
    @GetMapping("/{id}")
    public Todo getTodo(@PathVariable Long id) {
        return todoService.getTodoById(id)
            .orElseThrow(() -> new RuntimeException("Todo not found"));
    }
}
```

### 6.2 @ExceptionHandler
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ErrorResponse> handleRuntimeException(
        RuntimeException e
    ) {
        ErrorResponse error = new ErrorResponse(
            HttpStatus.NOT_FOUND.value(),
            e.getMessage()
        );
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }
}

// ErrorResponse.java
public class ErrorResponse {
    private int status;
    private String message;
    
    // 생성자, getter, setter
}
```

---

## 7. 실습: 간단한 REST API 서버 (30분)

### 요구사항
1. Todo 엔티티 생성
2. TodoController 생성
3. TodoService 생성
4. TodoRepository 생성
5. CRUD API 구현

### 엔티티 예시
```java
@Entity
@Table(name = "todos")
public class Todo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    private String description;
    private boolean completed;
    
    @CreatedDate
    private LocalDateTime createdAt;
    
    // 생성자, getter, setter
}
```

---

## 📝 오늘의 핵심 정리
1. ✅ Spring Boot 프로젝트 생성 및 실행
2. ✅ MVC 패턴 이해 및 구현
3. ✅ RESTful API 설계 및 구현
4. ✅ DTO를 사용한 데이터 전송
5. ✅ 예외 처리 방법

## 🏠 과제
1. 간단한 REST API 서버 만들기 (Todo CRUD)
2. Postman으로 API 테스트하기
3. 다음 주차 준비: JPA/Hibernate 문서 읽어오기

## 📚 참고 자료
- [Spring Boot 공식 문서](https://spring.io/projects/spring-boot)
- [Spring Boot 가이드](https://spring.io/guides)
- [RESTful API 설계 가이드](https://restfulapi.net/)

