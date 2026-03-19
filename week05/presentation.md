# 5주차: Spring Boot 심화

## 📋 학습 목표
- JPA/Hibernate를 이해하고 사용할 수 있다
- Spring Data JPA를 활용할 수 있다
- 엔티티 관계를 설계하고 매핑할 수 있다
- 데이터베이스 연동을 구현할 수 있다
- 쿼리 메서드를 작성할 수 있다

---

## 1. JPA/Hibernate 소개 (30분)

### 1.1 JPA란?
- **정의**: Java Persistence API - Java 객체와 데이터베이스 간 매핑을 위한 표준
- **💡 비전공자를 위한 한 줄**: "DB를 Java 객체처럼 다루게 해주는 도구. SQL을 직접 쓰지 않고 `save()`, `find()` 같은 메서드로 처리"
- **장점**:
  - 객체지향적 접근
  - 데이터베이스 독립성
  - 생산성 향상

### 1.2 Hibernate란?
- **정의**: JPA 구현체 중 하나
- **기능**: 객체-관계 매핑 (ORM)

### 1.3 JPA vs JDBC
- **JDBC (Java Database Connectivity)**:
  - SQL을 직접 문자열로 작성해야 함
  - ResultSet을 객체로 변환하는 반복 코드 필요
  - 데이터베이스마다 SQL 문법 차이 대응이 수동
- **JPA**:
  - Java 객체를 다루듯 DB를 조작 (예: `repository.save(todo)`)
  - SQL 생성과 객체 매핑을 JPA가 자동 처리
  - Hibernate가 MySQL, PostgreSQL, Oracle 등 다양한 DB 방언(Dialect) 지원
  - ** trade-off**: 복잡한 쿼리는 JPQL 또는 네이티브 SQL로 직접 작성 필요

---

## 2. 엔티티 설계 (90분)

### 2.1 @Entity 어노테이션
```java
@Entity
@Table(name = "todos")
public class Todo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 100)
    private String title;
    
    @Column(length = 500)
    private String description;
    
    private boolean completed;
    
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    private LocalDateTime updatedAt;
    
    // 생성자, getter, setter
}
```

### 2.2 주요 어노테이션
- `@Entity`: 엔티티 클래스
- `@Table`: 테이블 이름 지정
- `@Id`: 기본 키
- `@GeneratedValue`: 자동 생성 전략
- `@Column`: 컬럼 속성 지정
- `@CreatedDate`: 생성 시간 자동 설정
- `@LastModifiedDate`: 수정 시간 자동 설정

### 2.3 생성 전략
```java
@GeneratedValue(strategy = GenerationType.IDENTITY)  // MySQL, PostgreSQL
@GeneratedValue(strategy = GenerationType.SEQUENCE)  // Oracle
@GeneratedValue(strategy = GenerationType.TABLE)    // 모든 DB
@GeneratedValue(strategy = GenerationType.AUTO)      // 자동 선택
```

### 2.4 BaseEntity 생성
```java
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    private LocalDateTime updatedAt;
    
    // getter, setter
}

// 사용
@Entity
public class Todo extends BaseEntity {
    private String title;
    // ...
}
```

---

## 3. Spring Data JPA (90분)

### 3.1 Repository 인터페이스
```java
public interface TodoRepository extends JpaRepository<Todo, Long> {
    // 기본 메서드 제공:
    // - save(T entity)
    // - findById(ID id)
    // - findAll()
    // - deleteById(ID id)
    // - count()
    // 등등...
}
```

### 3.2 쿼리 메서드
```java
public interface TodoRepository extends JpaRepository<Todo, Long> {
    // 메서드 이름으로 쿼리 생성
    List<Todo> findByTitle(String title);
    List<Todo> findByCompleted(boolean completed);
    List<Todo> findByTitleContaining(String keyword);
    List<Todo> findByTitleAndCompleted(String title, boolean completed);
    
    // 정렬
    List<Todo> findByCompletedOrderByCreatedAtDesc(boolean completed);
    
    // 개수
    long countByCompleted(boolean completed);
    
    // 존재 여부
    boolean existsByTitle(String title);
}
```

### 3.3 @Query 어노테이션
```java
public interface TodoRepository extends JpaRepository<Todo, Long> {
    // JPQL (Java Persistence Query Language)
    @Query("SELECT t FROM Todo t WHERE t.completed = :completed")
    List<Todo> findTodosByCompleted(@Param("completed") boolean completed);
    
    // 네이티브 쿼리
    @Query(value = "SELECT * FROM todos WHERE completed = :completed", nativeQuery = true)
    List<Todo> findTodosByCompletedNative(@Param("completed") boolean completed);
    
    // 수정 쿼리
    @Modifying
    @Query("UPDATE Todo t SET t.completed = true WHERE t.id = :id")
    void markAsCompleted(@Param("id") Long id);
}
```

### 3.4 페이징 및 정렬
```java
public interface TodoRepository extends JpaRepository<Todo, Long> {
    Page<Todo> findByCompleted(boolean completed, Pageable pageable);
    List<Todo> findByCompleted(boolean completed, Sort sort);
}

// 사용
@Service
public class TodoService {
    public Page<Todo> getTodos(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return todoRepository.findAll(pageable);
    }
}
```

---

## 4. 엔티티 관계 매핑 (90분)

### 4.1 @OneToMany / @ManyToOne
```java
// User 엔티티
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String username;
    private String email;
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Todo> todos = new ArrayList<>();
}

// Todo 엔티티
@Entity
public class Todo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
}
```

### 4.2 @ManyToMany
```java
// User 엔티티
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToMany
    @JoinTable(
        name = "user_roles",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "role_id")
    )
    private Set<Role> roles = new HashSet<>();
}

// Role 엔티티
@Entity
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    @ManyToMany(mappedBy = "roles")
    private Set<User> users = new HashSet<>();
}
```

### 4.3 FetchType
- **EAGER (즉시 로딩)**: 연관 엔티티를 조회할 때 함께 한 번에 가져옴
  - 기본값: @OneToMany, @ManyToMany
  - **주의**: N+1 문제나 불필요한 조인으로 성능 저하 가능 → 필요한 경우에만 사용
- **LAZY (지연 로딩)**: 연관 엔티티에 실제로 접근할 때 조회
  - 기본값: @ManyToOne, @OneToOne
  - **권장**: 대부분의 경우 LAZY 사용. 필요한 시점에만 DB 조회해 성능에 유리

```java
@ManyToOne(fetch = FetchType.LAZY)  // 지연 로딩 권장
@JoinColumn(name = "user_id")
private User user;
```

- **언제 EAGER를 쓸까요?** → 해당 연관 데이터를 거의 항상 함께 쓰는 소수의 관계일 때만 고려

### 4.4 CascadeType
```java
@OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
// ALL: 모든 작업 전파
// PERSIST: 저장만 전파
// REMOVE: 삭제만 전파
// MERGE: 병합만 전파
private List<Todo> todos;
```

---

## 5. 데이터베이스 설정 (60분)

### 5.0 PostgreSQL 설치 - 따라하기 (비전공자용)

- **💡 왜 PostgreSQL?** 무료·오픈소스 관계형 DB. Spring Boot와 잘 맞고, 실무에서도 자주 사용
- **설치 (Windows)**  
  1. [postgresql.org/download/windows](https://www.postgresql.org/download/windows) 접속  
  2. "Download the installer" → 본인 OS에 맞게 다운로드  
  3. 설치 시 **비밀번호** 설정 (postgres 사용자용. 꼭 기억해두기)  
  4. 포트 5432는 기본값 그대로
- **설치 (Mac)**  
  1. **방법 A - Homebrew** (Homebrew 있으면):  
     - `brew install postgresql@15` → `brew services start postgresql@15`  
     - 기본 사용자: 현재 Mac 로그인 계정. `psql postgres` 로 접속
  2. **방법 B - Postgres.app** (GUI, 초보자 추천):  
     - [postgresapp.com](https://postgresapp.com/) 다운로드 → Applications로 드래그  
     - 실행 후 "Initialize" 클릭  
  3. **방법 C - EDB Installer** (Windows와 동일 방식):  
     - [postgresql.org/download/macos](https://www.postgresql.org/download/macos) 접속  
     - EDB 다운로드 → .dmg 실행 → 설치
- **DB 생성**  
  - **Windows**: pgAdmin 실행 또는 터미널 `psql -U postgres` 접속  
  - **Mac**: 터미널에서 `psql postgres` (Homebrew) 또는 `psql -U postgres` (EDB/Postgres.app) 접속  
  - 접속 후 `CREATE DATABASE tododb;` 실행

### 5.1 PostgreSQL 설정
```properties
# application.properties
spring.datasource.url=jdbc:postgresql://localhost:5432/tododb
spring.datasource.username=postgres
spring.datasource.password=yourpassword
spring.datasource.driver-class-name=org.postgresql.Driver

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
```

### 5.2 ddl-auto 옵션
- **create**: 애플리케이션 시작 시 기존 테이블 삭제 후 새로 생성 (주의: 데이터 삭제됨)
- **update**: 시작 시 엔티티에 맞게 스키마를 변경 (컬럼 추가 등). **개발 환경**에서 편리
- **validate**: 엔티티와 DB 스키마가 일치하는지 검증만. 불일치 시 기동 실패
- **none**: DDL 관련 작업을 하지 않음
- **create-drop**: create와 동일하나, 종료 시 테이블을 삭제 (테스트용)

- **실무 권장**: 개발은 `update`, 운영(프로덕션)은 `validate` 또는 `none`
  - 운영에서는 Flyway, Liquibase 같은 마이그레이션 도구로 스키마 관리

### 5.3 데이터 초기화
```sql
-- src/main/resources/data.sql
INSERT INTO todos (title, description, completed, created_at) VALUES
('리액트 공부하기', 'React Hooks 학습', false, NOW()),
('Spring Boot 공부하기', 'JPA 학습', false, NOW());
```

---

## 6. 실습: Todo API 서버 완성 (30분)

### 요구사항
1. Todo 엔티티 생성
2. User 엔티티 생성 (Todo와 관계)
3. Repository 생성
4. Service 및 Controller 구현
5. 데이터베이스 연동 테스트

### 엔티티 관계
```
User (1) -----< (N) Todo
```

---

## 📝 오늘의 핵심 정리
1. ✅ JPA/Hibernate 이해
2. ✅ 엔티티 설계 및 매핑
3. ✅ Spring Data JPA 활용
4. ✅ 엔티티 관계 매핑
5. ✅ 데이터베이스 연동

## 🏠 과제
1. User와 Todo 관계를 가진 API 서버 만들기
2. 쿼리 메서드 연습
3. 다음 주차 준비: Axios 문서 읽어오기

## 📚 참고 자료
- [Spring Data JPA 공식 문서](https://spring.io/projects/spring-data-jpa)
- [JPA 공식 문서](https://www.oracle.com/java/technologies/persistence-jsp.html)
- [Hibernate 공식 문서](https://hibernate.org/)

