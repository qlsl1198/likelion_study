# 7주차 보조 자료

## Spring Security 고급 설정

### 역할 기반 접근 제어
```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .requestMatchers("/api/user/**").hasAnyRole("USER", "ADMIN")
                .anyRequest().authenticated();
        
        return http.build();
    }
}
```

### 메서드 레벨 보안
```java
@PreAuthorize("hasRole('ADMIN')")
@GetMapping("/admin/users")
public List<User> getAllUsers() {
    return userService.getAllUsers();
}
```

## JWT 토큰 갱신

### Refresh Token 구현
```java
public class JwtTokenProvider {
    
    public String createRefreshToken(String username) {
        Claims claims = Jwts.claims().setSubject(username);
        Date now = new Date();
        Date validity = new Date(now.getTime() + 86400000); // 24시간
        
        return Jwts.builder()
            .setClaims(claims)
            .setIssuedAt(now)
            .setExpiration(validity)
            .signWith(SignatureAlgorithm.HS256, secretKey)
            .compact();
    }
}

@PostMapping("/auth/refresh")
public ResponseEntity<LoginResponseDTO> refreshToken(@RequestBody RefreshTokenRequest request) {
    String newToken = jwtTokenProvider.refreshToken(request.getRefreshToken());
    // 새 토큰 반환
}
```

## 비밀번호 정책

### 비밀번호 검증
```java
public class PasswordValidator {
    private static final String PASSWORD_PATTERN = 
        "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$";
    
    public boolean isValid(String password) {
        return password.matches(PASSWORD_PATTERN);
    }
}
```

## OAuth2 인증 (선택사항)

### Google OAuth 설정
```java
@Configuration
public class OAuth2Config {
    
    @Bean
    public ClientRegistrationRepository clientRegistrationRepository() {
        return new InMemoryClientRegistrationRepository(
            googleClientRegistration()
        );
    }
    
    private ClientRegistration googleClientRegistration() {
        return ClientRegistration.withRegistrationId("google")
            .clientId("your-client-id")
            .clientSecret("your-client-secret")
            .scope("openid", "profile", "email")
            .authorizationUri("https://accounts.google.com/o/oauth2/auth")
            .tokenUri("https://oauth2.googleapis.com/token")
            .userInfoUri("https://www.googleapis.com/oauth2/v3/userinfo")
            .userNameAttributeName(IdTokenClaimNames.SUB)
            .clientName("Google")
            .build();
    }
}
```

## 파일 업로드 고급

### 파일 크기 제한
```properties
# application.properties
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB
```

### 파일 타입 검증
```java
@Service
public class FileService {
    private static final List<String> ALLOWED_TYPES = 
        Arrays.asList("image/jpeg", "image/png", "image/gif");
    
    public String saveFile(MultipartFile file) throws IOException {
        if (!ALLOWED_TYPES.contains(file.getContentType())) {
            throw new IllegalArgumentException("Invalid file type");
        }
        // 저장 로직
    }
}
```

## 인증 상태 관리 패턴

### 토큰 만료 처리
```javascript
api.interceptors.response.use(
    response => response,
    async error => {
        const originalRequest = error.config;
        
        if (error.response?.status === 401 && !originalRequest._retry) {
            originalRequest._retry = true;
            
            try {
                // 토큰 갱신 시도
                const response = await api.post('/auth/refresh');
                const { token } = response.data;
                localStorage.setItem('token', token);
                
                originalRequest.headers.Authorization = `Bearer ${token}`;
                return api(originalRequest);
            } catch (refreshError) {
                // 갱신 실패 시 로그아웃
                localStorage.removeItem('token');
                window.location.href = '/login';
            }
        }
        
        return Promise.reject(error);
    }
);
```

## 보안 모범 사례

### HTTPS 사용
- 프로덕션 환경에서는 반드시 HTTPS 사용
- 토큰을 쿠키에 저장할 경우 httpOnly, secure 플래그 설정

### 토큰 저장
```javascript
// localStorage 대신 httpOnly 쿠키 사용 권장 (XSS 방지)
// 또는 메모리에만 저장 (페이지 새로고침 시 재로그인 필요)
```

### CSRF 보호
```java
// REST API는 CSRF 비활성화 가능
// 하지만 폼 기반 인증은 CSRF 토큰 필요
```

