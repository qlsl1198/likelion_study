# 4주차 실습 문제

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

## 실습 2: Todo CRUD API (60분)

### 목표
완전한 CRUD 기능을 가진 Todo API를 만듭니다.

### 문제
다음 기능을 구현하세요:

1. **Todo 엔티티**
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

2. **TodoRepository**
   - JpaRepository 상속

3. **TodoService**
   - getAllTodos()
   - getTodoById(Long id)
   - createTodo(Todo todo)
   - updateTodo(Long id, Todo todo)
   - deleteTodo(Long id)

4. **TodoController**
   - GET `/api/todos`: 모든 Todo 조회
   - GET `/api/todos/{id}`: 특정 Todo 조회
   - POST `/api/todos`: Todo 생성
   - PUT `/api/todos/{id}`: Todo 수정
   - DELETE `/api/todos/{id}`: Todo 삭제

### 제출물
- 모든 클래스 파일
- Postman 테스트 결과 스크린샷

---

## 실습 3: DTO 사용하기 (40분)

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

## 실습 4: 예외 처리 (30분)

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

## 실습 5: 검증 추가 (30분)

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

## 평가 기준

| 실습 | 배점 | 평가 기준 |
|------|------|-----------|
| 실습 1 | 15점 | 기본 API 정상 작동 |
| 실습 2 | 30점 | CRUD 완전 구현 |
| 실습 3 | 20점 | DTO 정상 사용 |
| 실습 4 | 15점 | 예외 처리 구현 |
| 실습 5 | 20점 | 검증 구현 |
| 종합 실습 | 보너스 | 추가 점수 |

**총점: 100점**

---

## 제출 방법
1. 각 실습을 개별 패키지로 구성
2. GitHub에 업로드
3. README.md에 API 문서 작성
4. Postman 테스트 결과 포함

## 팁
- Postman을 사용하여 API 테스트하기
- 로깅을 활용하여 디버깅하기
- 예외 메시지를 명확하게 작성하기
- 코드에 주석 추가하기

