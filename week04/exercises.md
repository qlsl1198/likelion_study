# 4주차 실습 문제

## 제출 (GitHub 조직)

- **과제 저장소**: [likelion-session/week04-assignment](https://github.com/likelion-session/week04-assignment)  
- **방식**: 저장소를 **Fork**한 뒤 `submissions/본인GitHub아이디/`에 코드를 넣고 **Pull Request**로 제출합니다.  
- 상세 절차는 저장소의 [SUBMISSION.md](https://github.com/likelion-session/week04-assignment/blob/main/SUBMISSION.md)를 따릅니다.

### 비전공자·입문자 안내 (난이도)

- **과제 통과 최소선(권장)**: **실습 1** + **실습 2A (메모리 Todo API)** 만 완료해도 **제출·채점 대상**입니다. DB·JPA를 몰라도 됩니다.  
- **실습 2B**는 JPA·DB를 배운 분을 위한 **심화**이고, **실습 3~5**는 **시간 남을 때** 하면 됩니다.  
- **한 개의 Spring Boot 프로젝트**에 순서대로 붙여도 되고, 막히면 강사에게 **어느 단계에서 에러인지**를 알려 주세요.

---

## 실습 1: 첫 번째 REST API 만들기 (30분)

### 목표
간단한 REST API를 만들어봅니다.

### 문제
다음 기능을 가진 API를 만드세요:

1. **HelloController 생성**
   - GET `/api/hello`: "Hello, Spring Boot!" 반환
   - GET `/api/hello/{name}`: "Hello, {name}!" 반환

2. **애플리케이션 실행 및 테스트**
   - 브라우저에서 접속하여 확인
   - Postman으로 테스트

### 제출물
- HelloController.java 파일
- 실행 결과 스크린샷

---

## 실습 2A: Todo API — 입문 (메모리, JPA·DB 없음) **← 비전공 권장**

### 목표
**DB 없이** Java 컬렉션으로 Todo를 저장하고, REST로 주고받습니다. (슬라이드의 **Controller → Service** 흐름만 연습)

### 문제
1. **Todo 클래스** (일반 Java 클래스, **`@Entity` 사용 안 함**)
   - 필드 예: `Long id`, `String title`, `String description`, `boolean completed`, `LocalDateTime createdAt` (또는 `String`으로 단순화해도 됨)
   - `id`는 서비스에서 `1, 2, 3…`처럼 **직접 증가**시켜도 됩니다.

2. **TodoService**
   - 내부에 `List<Todo>` 또는 `Map<Long, Todo>` 하나만 두고 저장
   - `getAllTodos()`, `getTodoById(Long id)`, `createTodo(...)`, `deleteTodo(Long id)` **필수**
   - **`updateTodo`(PUT)** 는 **선택** — 어렵으면 생략하고 README에 “미구현”이라고 적어도 됩니다.

3. **TodoController** (`@RestController`)
   - GET `/api/todos` — 전체 목록
   - GET `/api/todos/{id}` — 단건 (없으면 404 또는 JSON 메시지)
   - POST `/api/todos` — JSON으로 새 Todo 추가
   - DELETE `/api/todos/{id}` — 삭제

### 제출물
- 위 클래스·서비스·컨트롤러 코드
- Postman으로 **GET / POST / DELETE** 한 번씩 본 스크린샷 (또는 캡처 1장에 모아도 됨)

---

## 실습 2B: Todo CRUD API — 심화 (JPA + DB) **← 선택(도전)**

### 목표
슬라이드·강의와 동일하게 **엔티티·Repository**로 CRUD를 구현합니다.

### 문제
1. **Todo 엔티티** (`@Entity`)
   ```java
   @Entity
   public class Todo {
       @Id
       @GeneratedValue(strategy = GenerationType.IDENTITY)
       private Long id;
       private String title;
       private String description;
       private boolean completed;
       private LocalDateTime createdAt;
   }
   ```

2. **TodoRepository** — `JpaRepository<Todo, Long>` 상속

3. **TodoService** — `getAllTodos()`, `getTodoById`, `createTodo`, `updateTodo`, `deleteTodo`

4. **TodoController** — GET 목록·GET 단건·POST·PUT·DELETE

### 제출물
- 관련 클래스 전부
- Postman 테스트 스크린샷

---

## 실습 3: DTO 사용하기 (40분) — 선택(도전)

### 목표
DTO를 사용하여 API를 개선합니다.

### 문제
다음 DTO를 만들고 사용하세요:

1. **TodoRequestDTO**
   - title (필수)
   - description (선택)
   - completed (기본값: false)

2. **TodoResponseDTO**
   - id
   - title
   - description
   - completed
   - createdAt

3. **컨트롤러 수정**
   - RequestDTO로 받기
   - ResponseDTO로 반환하기

### 제출물
- DTO 클래스 파일
- 수정된 Controller 파일
- 실행 결과 스크린샷

---

## 실습 4: 예외 처리 (30분) — 선택(도전)

### 목표
예외 처리를 추가합니다.

### 문제
다음 예외 처리를 구현하세요:

1. **커스텀 예외 클래스**
   ```java
   public class TodoNotFoundException extends RuntimeException {
       public TodoNotFoundException(Long id) {
           super("Todo not found with id: " + id);
       }
   }
   ```

2. **GlobalExceptionHandler**
   - TodoNotFoundException 처리
   - 404 상태 코드 반환
   - ErrorResponse DTO 사용

3. **서비스 수정**
   - TodoNotFoundException 던지기

### 제출물
- 예외 클래스 파일
- ExceptionHandler 파일
- 실행 결과 스크린샷 (존재하지 않는 ID 조회 시)

---

## 실습 5: 검증 추가 (30분) — 선택(도전)

### 목표
입력값 검증을 추가합니다.

### 문제
다음 검증을 추가하세요:

1. **TodoRequestDTO 검증**
   - title: 필수, 1-100자
   - description: 선택, 최대 500자

2. **컨트롤러 수정**
   - @Valid 어노테이션 추가

3. **에러 응답**
   - 검증 실패 시 400 Bad Request
   - 에러 메시지 포함

### 제출물
- 수정된 DTO 파일
- 수정된 Controller 파일
- 검증 실패 시 응답 스크린샷

---

## 종합 실습: 완전한 Todo API (선택사항)

### 목표
모든 기능을 포함한 완전한 Todo API를 만듭니다.

### 요구사항
1. **기본 CRUD**
   - 모든 CRUD 기능 구현

2. **추가 기능**
   - 완료된 Todo만 조회: GET `/api/todos?completed=true`
   - 제목으로 검색: GET `/api/todos?title=keyword`
   - 페이지네이션: GET `/api/todos?page=0&size=10`

3. **DTO 사용**
   - RequestDTO, ResponseDTO 사용

4. **예외 처리**
   - 모든 예외 처리

5. **검증**
   - 입력값 검증

6. **CORS 설정**
   - 프론트엔드 연동 준비

### 제출물
- 전체 프로젝트 파일
- Postman 컬렉션 (API 테스트)
- README.md (API 문서)

---

## 평가 기준 (비전공·입문 기준 반영)

| 실습 | 배점 | 평가 기준 |
|------|------|-----------|
| 실습 1 | 25점 | Hello API 동작, Postman 또는 브라우저 확인 |
| 실습 2 | 60점 | **2A(메모리)** 만으로 만점 가능. **2B(JPA)** 로 구현해도 동일 배점(강사는 둘 중 **하나**로 채점) |
| 실습 3 | 5점 | 선택 — DTO 시도 시 |
| 실습 4 | 5점 | 선택 |
| 실습 5 | 5점 | 선택 |
| 종합 실습 | 보너스 | 추가 점수 |

**총점: 100점** — **실습 1 + 실습 2(2A 또는 2B)** 만으로 **85점**까지 나오도록 했습니다. 실습 3~5·종합은 **건너뛰어도** 과제 제출로 인정합니다.

---

## 제출 방법
1. **하나의 Spring Boot 프로젝트**에 넣어도 되고, 폴더를 나눠도 됩니다.
2. `README.md`에 **실행 방법**(`./mvnw spring-boot:run` 등), **JDK 버전**, **완료한 실습 번호**를 적습니다.
3. Postman 스크린샷은 **한 장이라도** 있으면 됩니다. (과제 저장소 Fork·PR 방식은 상단 **제출** 안내 참고)

## 팁
- 먼저 **실습 1 → 2A**만 끝낸 뒤, 여유 있을 때 2B·3으로 넘어가기
- Postman에서 **Body → raw → JSON** 으로 POST 연습하기
- 에러가 나면 **터미널 로그 마지막 20줄**을 복사해 두면 질문받기 좋습니다
- 코드에 **한 줄짜리 주석**으로 “이 API가 뭐 하는지”만 적어도 충분합니다

