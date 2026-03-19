# 5주차 보조 자료

## 엔티티 설계 가이드

### 네이밍 전략
```java
@Entity
@Table(name = "todo_items")  // 테이블 이름 명시
public class Todo {
    @Column(name = "todo_title")  // 컬럼 이름 명시
    private String title;
}
```

### 기본값 설정
```java
@Entity
public class Todo {
    @Column(columnDefinition = "boolean default false")
    private boolean completed;
    
    @Column(columnDefinition = "varchar(100) default 'Untitled'")
    private String title;
}
```

## 복합 키 사용

### @EmbeddedId 사용
```java
@Embeddable
public class OrderItemId implements Serializable {
    private Long orderId;
    private Long itemId;
}

@Entity
public class OrderItem {
    @EmbeddedId
    private OrderItemId id;
    
    private int quantity;
}
```

## 쿼리 메서드 키워드

### 주요 키워드
- `findBy`, `readBy`, `getBy`: 조회
- `countBy`: 개수
- `existsBy`: 존재 여부
- `deleteBy`, `removeBy`: 삭제

### 조건 키워드
- `And`, `Or`: 논리 연산
- `Is`, `Equals`: 같음
- `IsNot`, `Not`: 같지 않음
- `IsNull`, `IsNotNull`: NULL 체크
- `Like`, `NotLike`: 패턴 매칭
- `StartingWith`, `EndingWith`, `Containing`: 문자열 검색
- `LessThan`, `LessThanEqual`: 미만, 이하
- `GreaterThan`, `GreaterThanEqual`: 초과, 이상
- `Between`: 범위
- `In`: 포함
- `OrderBy`: 정렬

### 예시
```java
List<Todo> findByTitleContainingAndCompletedOrderByCreatedAtDesc(
    String keyword, 
    boolean completed
);

long countByCreatedAtBetween(LocalDateTime start, LocalDateTime end);

List<Todo> findByIdIn(List<Long> ids);
```

## 트랜잭션 관리

### @Transactional
```java
@Service
@Transactional
public class TodoService {
    public Todo createTodo(Todo todo) {
        // 자동으로 트랜잭션 시작
        Todo saved = todoRepository.save(todo);
        // 커밋 또는 롤백
        return saved;
    }
    
    @Transactional(readOnly = true)
    public List<Todo> getAllTodos() {
        // 읽기 전용 트랜잭션
        return todoRepository.findAll();
    }
}
```

## 엔티티 이벤트

### @PrePersist, @PreUpdate
```java
@Entity
public class Todo {
    @PrePersist
    public void prePersist() {
        this.createdAt = LocalDateTime.now();
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
```

## N+1 문제 해결

### 문제 상황
```java
// User를 조회할 때마다 Todo도 조회됨 (N+1 문제)
List<User> users = userRepository.findAll();
for (User user : users) {
    System.out.println(user.getTodos().size());  // 각각 쿼리 실행
}
```

### 해결 방법 1: Fetch Join
```java
@Query("SELECT u FROM User u JOIN FETCH u.todos")
List<User> findAllWithTodos();
```

### 해결 방법 2: @EntityGraph
```java
@EntityGraph(attributePaths = {"todos"})
List<User> findAll();
```

## 커스텀 Repository

### 인터페이스 정의
```java
public interface TodoRepositoryCustom {
    List<Todo> findCustomTodos(String keyword);
}
```

### 구현 클래스
```java
@Repository
public class TodoRepositoryCustomImpl implements TodoRepositoryCustom {
    @PersistenceContext
    private EntityManager entityManager;
    
    @Override
    public List<Todo> findCustomTodos(String keyword) {
        // 커스텀 로직 구현
        return entityManager.createQuery(...).getResultList();
    }
}
```

### 메인 Repository에 상속
```java
public interface TodoRepository extends JpaRepository<Todo, Long>, TodoRepositoryCustom {
    // ...
}
```

## Specification 사용

### 의존성 추가
```xml
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-jpa</artifactId>
</dependency>
```

### Repository 수정
```java
public interface TodoRepository extends JpaRepository<Todo, Long>, JpaSpecificationExecutor<Todo> {
}
```

### 사용
```java
@Service
public class TodoService {
    public List<Todo> searchTodos(String keyword, Boolean completed) {
        Specification<Todo> spec = Specification.where(null);
        
        if (keyword != null) {
            spec = spec.and((root, query, cb) -> 
                cb.like(root.get("title"), "%" + keyword + "%")
            );
        }
        
        if (completed != null) {
            spec = spec.and((root, query, cb) -> 
                cb.equal(root.get("completed"), completed)
            );
        }
        
        return todoRepository.findAll(spec);
    }
}
```

