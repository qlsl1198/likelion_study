# 7주차: 인증/인가 및 고급 기능

## 💡 비전공자를 위한 한눈에 보기

- **인증(Authentication)**: "너 누구야?" → 로그인으로 신원 확인
- **인가(Authorization)**: "이거 할 수 있어?" → 권한 확인 (예: 관리자만 삭제 가능)
- **JWT**: 로그인 성공 시 서버가 발급하는 "입장권". 이후 요청에 이 토큰을 붙여 보내면 "이미 로그인된 사용자"로 인식
- **BCrypt**: 비밀번호를 암호화하는 방식. DB에 평문으로 저장하면 유출 시 위험하므로, 복호화 불가능한 형태로 저장

---

## 📋 학습 목표
- JWT 기반 인증을 이해하고 구현할 수 있다
- Spring Security를 설정하고 사용할 수 있다
- React에서 인증 상태를 관리할 수 있다
- 보호된 라우트를 구현할 수 있다
- 파일 업로드 기능을 구현할 수 있다

---

## 1. JWT 인증 소개 (30분)

### 1.1 JWT란?
- **정의**: JSON Web Token - 인증 정보를 안전하게 전송하기 위한 토큰 (Base64로 인코딩된 문자열)
- **구조**: `Header.Payload.Signature` (점으로 구분된 세 부분)
  - **Header**: 토큰 타입(JWT)과 해시 알고리즘 정보
  - **Payload**: 사용자 ID, 역할, 만료 시간 등 클레임(claim) - **민감 정보 넣지 말 것**
  - **Signature**: Header+Payload를 비밀키로 서명하여 변조 여부 검증
- **세션 vs JWT**:
  - 세션: 서버에 로그인 상태 저장 → 서버 부하, 여러 서버일 때 세션 공유 복잡
  - JWT: 토큰에 정보 담아 클라이언트가 보관 → 서버가 상태를 기억하지 않음 (Stateless)
- **장점**: Stateless로 확장성 좋음, 모바일/웹 등 다양한 플랫폼 지원, 마이크로서비스에 적합

### 1.2 JWT 동작 방식
```
1. 사용자 로그인
2. 서버에서 JWT 생성 및 반환
3. 클라이언트가 JWT 저장 (localStorage 등)
4. 이후 요청에 JWT 포함
5. 서버에서 JWT 검증
```

---

## 2. Spring Security 설정 (90분)

### 2.1 의존성 추가
```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.11.5</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.11.5</version>
</dependency>
```

### 2.2 Security 설정
```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    private final JwtTokenProvider jwtTokenProvider;
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            .and()
            .authorizeHttpRequests()
                .requestMatchers("/api/auth/**").permitAll()
                .anyRequest().authenticated()
            .and()
            .addFilterBefore(new JwtAuthenticationFilter(jwtTokenProvider), 
                UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

- **BCrypt를 쓰는 이유**: 비밀번호는 절대 평문으로 저장하면 안 됨. BCrypt는 단방향 해시라 역추적 불가능하고, 솔트(salt)를 자동 적용해 같은 비밀번호도 다른 해시값을 가짐

### 2.2-1 의존성 추가 - 따라하기 (pom.xml)

- **IntelliJ 열기**: Windows: `pom.xml` 더블클릭 / Mac: Finder에서 프로젝트 폴더 열고 `pom.xml` 더블클릭
1. IntelliJ에서 `pom.xml` 열기
2. `</dependencies>` 태그 **바로 위**에 아래 블록 추가
3. 저장 후 Maven 새로고침 (우클릭 → Maven → Reload project)

```xml
<!-- Spring Security -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<!-- JWT (jjwt) -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
```

- **💡 scope runtime**: 실행 시에만 필요. 컴파일에는 포함되지 않음

### 2.3 JWT 유틸리티 클래스
```java
@Component
public class JwtTokenProvider {
    
    private String secretKey = "your-secret-key";
    private long validityInMilliseconds = 3600000; // 1시간
    
    public String createToken(String username, List<String> roles) {
        Claims claims = Jwts.claims().setSubject(username);
        claims.put("roles", roles);
        
        Date now = new Date();
        Date validity = new Date(now.getTime() + validityInMilliseconds);
        
        return Jwts.builder()
            .setClaims(claims)
            .setIssuedAt(now)
            .setExpiration(validity)
            .signWith(SignatureAlgorithm.HS256, secretKey)
            .compact();
    }
    
    public String getUsername(String token) {
        return Jwts.parser()
            .setSigningKey(secretKey)
            .parseClaimsJws(token)
            .getBody()
            .getSubject();
    }
    
    public boolean validateToken(String token) {
        try {
            Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }
}
```

### 2.4 JWT 필터
```java
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    
    private final JwtTokenProvider jwtTokenProvider;
    
    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                   HttpServletResponse response, 
                                   FilterChain filterChain) 
        throws ServletException, IOException {
        
        String token = resolveToken(request);
        
        if (token != null && jwtTokenProvider.validateToken(token)) {
            Authentication auth = jwtTokenProvider.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(auth);
        }
        
        filterChain.doFilter(request, response);
    }
    
    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
```

---

## 3. 인증 API 구현 (90분)

### 3.1 User 엔티티
```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String username;
    
    @Column(nullable = false)
    private String password;
    
    private String email;
    
    @ElementCollection(fetch = FetchType.EAGER)
    @Enumerated(EnumType.STRING)
    private Set<Role> roles = new HashSet<>();
    
    // 생성자, getter, setter
}

enum Role {
    ROLE_USER, ROLE_ADMIN
}
```

### 3.2 인증 DTO
```java
public class LoginRequestDTO {
    private String username;
    private String password;
    // getter, setter
}

public class LoginResponseDTO {
    private String token;
    private String type = "Bearer";
    private String username;
    // getter, setter
}

public class SignupRequestDTO {
    private String username;
    private String password;
    private String email;
    // getter, setter
}
```

### 3.3 Auth Controller
```java
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    
    private final AuthService authService;
    
    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody SignupRequestDTO request) {
        try {
            authService.signup(request);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
    
    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@RequestBody LoginRequestDTO request) {
        LoginResponseDTO response = authService.login(request);
        return ResponseEntity.ok(response);
    }
}
```

### 3.4 Auth Service
```java
@Service
public class AuthService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    
    public void signup(SignupRequestDTO request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new RuntimeException("Username already exists");
        }
        
        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setEmail(request.getEmail());
        user.setRoles(Set.of(Role.ROLE_USER));
        
        userRepository.save(user);
    }
    
    public LoginResponseDTO login(LoginRequestDTO request) {
        User user = userRepository.findByUsername(request.getUsername())
            .orElseThrow(() -> new RuntimeException("Invalid credentials"));
        
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid credentials");
        }
        
        String token = jwtTokenProvider.createToken(
            user.getUsername(),
            user.getRoles().stream()
                .map(Enum::name)
                .collect(Collectors.toList())
        );
        
        LoginResponseDTO response = new LoginResponseDTO();
        response.setToken(token);
        response.setUsername(user.getUsername());
        
        return response;
    }
}
```

---

## 4. React에서 인증 구현 (90분)

### 4.1 Auth Context
```javascript
// contexts/AuthContext.js
import { createContext, useContext, useState, useEffect } from 'react';
import api from '../api/axios';

const AuthContext = createContext();

export function AuthProvider({ children }) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    
    useEffect(() => {
        const token = localStorage.getItem('token');
        if (token) {
            // 토큰 검증 및 사용자 정보 가져오기
            fetchUser();
        } else {
            setLoading(false);
        }
    }, []);
    
    const fetchUser = async () => {
        try {
            const response = await api.get('/auth/me');
            setUser(response.data);
        } catch (error) {
            localStorage.removeItem('token');
        } finally {
            setLoading(false);
        }
    };
    
    const login = async (username, password) => {
        const response = await api.post('/auth/login', { username, password });
        const { token } = response.data;
        localStorage.setItem('token', token);
        await fetchUser();
    };
    
    const signup = async (username, password, email) => {
        await api.post('/auth/signup', { username, password, email });
    };
    
    const logout = () => {
        localStorage.removeItem('token');
        setUser(null);
    };
    
    return (
        <AuthContext.Provider value={{ user, loading, login, signup, logout }}>
            {children}
        </AuthContext.Provider>
    );
}

export function useAuth() {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error('useAuth must be used within AuthProvider');
    }
    return context;
}
```

### 4.2 Axios 인터셉터 설정
```javascript
// api/axios.js
import axios from 'axios';

const api = axios.create({
    baseURL: 'http://localhost:8080/api'
});

api.interceptors.request.use(
    config => {
        const token = localStorage.getItem('token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    error => {
        return Promise.reject(error);
    }
);

api.interceptors.response.use(
    response => response,
    error => {
        if (error.response?.status === 401) {
            localStorage.removeItem('token');
            window.location.href = '/login';
        }
        return Promise.reject(error);
    }
);

export default api;
```

### 4.3 Protected Route
```javascript
// components/ProtectedRoute.js
import { Navigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

function ProtectedRoute({ children }) {
    const { user, loading } = useAuth();
    
    if (loading) {
        return <div>Loading...</div>;
    }
    
    if (!user) {
        return <Navigate to="/login" />;
    }
    
    return children;
}
```

### 4.4 Login 컴포넌트
```javascript
// components/Login.js
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

function Login() {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const { login } = useAuth();
    const navigate = useNavigate();
    
    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            await login(username, password);
            navigate('/');
        } catch (err) {
            setError('Login failed');
        }
    };
    
    return (
        <form onSubmit={handleSubmit}>
            <input
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                placeholder="Username"
            />
            <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Password"
            />
            {error && <div>{error}</div>}
            <button type="submit">Login</button>
        </form>
    );
}
```

---

## 5. 파일 업로드 (60분)

### 5.1 Spring Boot 파일 업로드
```java
@RestController
@RequestMapping("/api/files")
public class FileController {
    
    @PostMapping("/upload")
    public ResponseEntity<String> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            String fileName = fileService.saveFile(file);
            return ResponseEntity.ok(fileName);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}

@Service
public class FileService {
    private final String uploadDir = "uploads/";
    
    public String saveFile(MultipartFile file) throws IOException {
        String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        Path filePath = Paths.get(uploadDir + fileName);
        Files.createDirectories(filePath.getParent());
        Files.write(filePath, file.getBytes());
        return fileName;
    }
}
```

### 5.2 React 파일 업로드
```javascript
function FileUpload() {
    const [file, setFile] = useState(null);
    const [uploading, setUploading] = useState(false);
    
    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!file) return;
        
        const formData = new FormData();
        formData.append('file', file);
        
        setUploading(true);
        try {
            const response = await api.post('/files/upload', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            });
            console.log('Uploaded:', response.data);
        } catch (error) {
            console.error('Upload failed:', error);
        } finally {
            setUploading(false);
        }
    };
    
    return (
        <form onSubmit={handleSubmit}>
            <input
                type="file"
                onChange={(e) => setFile(e.target.files[0])}
            />
            <button type="submit" disabled={uploading}>
                {uploading ? 'Uploading...' : 'Upload'}
            </button>
        </form>
    );
}
```

---

## 6. 실습: 인증 기능 추가 (30분)

### 요구사항
1. 회원가입/로그인 API 구현
2. JWT 토큰 발급 및 검증
3. React에서 인증 상태 관리
4. 보호된 라우트 구현

---

## 📝 오늘의 핵심 정리
1. ✅ JWT 인증 이해 및 구현
2. ✅ Spring Security 설정
3. ✅ 인증 API 구현
4. ✅ React에서 인증 상태 관리
5. ✅ 파일 업로드 기능

## 🏠 과제
1. 인증 기능이 포함된 Todo 앱 완성하기
2. 보호된 라우트 구현하기
3. 다음 주차 준비: 배포 문서 읽어오기

## 📚 참고 자료
- [Spring Security 공식 문서](https://spring.io/projects/spring-security)
- [JWT 공식 사이트](https://jwt.io/)
- [React Router 인증](https://reactrouter.com/en/main/start/overview)

