# 8주차 보조 자료

## 빌드 최적화 팁

### React 최적화
```javascript
// 코드 스플리팅
const LazyComponent = React.lazy(() => import('./LazyComponent'));

// 이미지 최적화
import { LazyLoadImage } from 'react-lazy-load-image-component';

// 번들 분석
npm install --save-dev webpack-bundle-analyzer
```

### Spring Boot 최적화
```properties
# JVM 옵션
-Xms512m -Xmx1024m

# 프로파일 활성화
spring.profiles.active=prod
```

## 환경 변수 관리

### React 환경 변수
```bash
# .env.development
REACT_APP_API_URL=http://localhost:8080/api

# .env.production
REACT_APP_API_URL=https://api.production.com
```

### Spring Boot 환경 변수
```bash
# 시스템 환경 변수
export DATABASE_URL=jdbc:postgresql://...

# 또는 application.properties
spring.datasource.url=${DATABASE_URL}
```

## 배포 체크리스트

### 배포 전 확인사항
- [ ] 환경 변수 설정 완료
- [ ] 데이터베이스 연결 확인
- [ ] CORS 설정 확인
- [ ] HTTPS 설정 (프로덕션)
- [ ] 에러 로깅 설정
- [ ] 성능 테스트 완료
- [ ] 보안 검토 완료

## Docker Compose (선택사항)

### docker-compose.yml
```yaml
version: '3.8'
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: tododb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
  
  backend:
    build: ./backend
    ports:
      - "8080:8080"
    depends_on:
      - db
    environment:
      DATABASE_URL: jdbc:postgresql://db:5432/tododb
  
  frontend:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - backend
```

## 모니터링 도구

### Application Performance Monitoring (APM)
- **New Relic**: 종합 모니터링
- **Datadog**: 인프라 모니터링
- **Prometheus + Grafana**: 오픈소스 모니터링

### 로그 관리
- **ELK Stack**: Elasticsearch, Logstash, Kibana
- **CloudWatch**: AWS 로그 관리
- **Papertrail**: 간단한 로그 관리

## 보안 체크리스트

### 보안 확인사항
- [ ] 비밀번호 암호화
- [ ] JWT 토큰 안전하게 저장
- [ ] SQL 인젝션 방지 (JPA 사용 시 자동)
- [ ] XSS 방지
- [ ] CSRF 보호
- [ ] HTTPS 사용
- [ ] 환경 변수로 민감 정보 관리
- [ ] 정기적인 의존성 업데이트

## 성능 최적화

### 프론트엔드
- 이미지 최적화 및 지연 로딩
- 코드 스플리팅
- 메모이제이션 활용
- 불필요한 리렌더링 방지

### 백엔드
- 데이터베이스 인덱싱
- 쿼리 최적화
- 캐싱 전략
- 연결 풀링

## 트러블슈팅

### 일반적인 문제
1. **CORS 에러**: 백엔드 CORS 설정 확인
2. **환경 변수 미적용**: 빌드 시 환경 변수 확인
3. **데이터베이스 연결 실패**: 연결 문자열 확인
4. **빌드 실패**: 의존성 버전 확인
5. **배포 후 404**: 라우팅 설정 확인 (SPA)

## 백업 전략

### 데이터베이스 백업
```bash
# PostgreSQL 백업
pg_dump -U postgres tododb > backup.sql

# 복원
psql -U postgres tododb < backup.sql
```

### 자동 백업
- 데이터베이스 제공업체의 자동 백업 활용
- 정기적인 백업 스케줄 설정

