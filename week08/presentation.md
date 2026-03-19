# 8주차: 배포 및 최종 프로젝트

## 📋 학습 목표
- 프로젝트를 빌드하고 최적화할 수 있다
- 다양한 배포 플랫폼을 이해한다
- 프로젝트를 배포할 수 있다
- 코드 리뷰를 할 수 있다
- 최종 프로젝트를 완성하고 발표할 수 있다

---

## 1. 프로젝트 빌드 및 최적화 (60분)

### 1.1 React 빌드
```bash
# 프로덕션 빌드
npm run build

# 빌드 결과물 확인
# build/ 폴더에 생성됨
```

### 1.2 빌드 최적화
- **💡 비전공자를 위한 이해**: 앱을 배포할 때 코드를 "포장"하는 과정. 최적화 = 포장을 작고 가볍게 만들어 사용자가 빨리 받게 함
- **코드 스플리팅**: 큰 번들을 여러 개의 작은 청크로 나누어, 페이지별로 필요한 코드만 로드 → 초기 로딩 속도 향상 (예: 로그인 페이지는 로그인 코드만, 대시보드는 대시보드 코드만)
- **압축**: JavaScript/CSS를 minify하여 파일 크기 축소 (공백·주석 제거, 변수명 축약)
- **트리 쉐이킹**: import 했지만 실제로 사용하지 않는 코드를 빌드 시 제거 → 번들 크기 감소 (쓰지 않는 import = 무거운 가방에서 빼기)
- **이미지 최적화**: WebP 형식 사용 (JPEG 대비 25~35% 작음), 지연 로딩(lazy loading) 적용

### 1.3 환경 변수 설정
```bash
# .env.production
REACT_APP_API_URL=https://api.yourdomain.com
```

### 1.4 Spring Boot 빌드
```bash
# Maven
./mvnw clean package

# Gradle
./gradlew build

# JAR 파일 생성
# target/ 또는 build/libs/ 폴더에 생성됨
```

### 1.5 프로파일 설정
```properties
# application-prod.properties
spring.datasource.url=jdbc:postgresql://prod-db:5432/tododb
spring.jpa.hibernate.ddl-auto=validate
logging.level.root=WARN
```

---

## 2. 배포 전략 (60분)

### 2.1 배포 옵션

#### 프론트엔드 배포
- **Vercel**: 가장 간단, 무료
- **Netlify**: 정적 사이트 호스팅
- **AWS S3 + CloudFront**: 확장성 좋음
- **GitHub Pages**: 간단한 프로젝트용

#### 백엔드 배포
- **AWS EC2**: 가상 서버
- **AWS Elastic Beanstalk**: 간편한 배포
- **Heroku**: 간단하지만 유료
- **Railway**: 무료 티어 제공
- **Docker + 클라우드**: 컨테이너 기반

### 2.2 Vercel 배포 (프론트엔드) - 따라하기
- **1단계**: `npm run build` 로 빌드가 정상인지 확인
- **2단계**: `npm i -g vercel` 로 Vercel CLI 전역 설치
  - Mac: 권한 에러 시 `sudo npm i -g vercel` 또는 `npm i -g vercel` (nvm 사용 시 sudo 불필요)
- **3단계**: React 프로젝트 폴더에서 `vercel` 실행
- **4단계**: 브라우저에서 로그인/가입 후, 터미널 질문에 응답 (기본값은 Enter)
- **또는** vercel.com 접속 → "Add New Project" → GitHub 연결 → 저장소 선택 → "Deploy" 클릭 후 자동 배포
- **환경 변수**: Vercel 대시보드 → Project → Settings → Environment Variables에서 `REACT_APP_API_URL` 추가

### 2.3 Railway 배포 (백엔드) - 따라하기
- **1단계**: https://railway.app/ 접속 → "Login with GitHub"으로 로그인
- **2단계**: "New Project" → "Deploy from GitHub repo" → 본인 저장소 선택
- **3단계**: Service 클릭 → Settings → Build Command: `./mvnw clean package -DskipTests`
- **4단계**: Start Command: `java -jar target/[프로젝트명]-0.0.1-SNAPSHOT.jar` (pom.xml의 artifactId 기준)
- **5단계**: Variables 탭에서 환경 변수 추가 (예: `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`, `SPRING_DATASOURCE_PASSWORD`)
- **6단계**: PostgreSQL 사용 시 Railway에서 "Add PostgreSQL" 플러그인 추가 → 연결 문자열 자동 생성

### 2.4 Docker 사용 (선택사항)
```dockerfile
# Dockerfile (Spring Boot)
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

```dockerfile
# Dockerfile (React)
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

---

## 3. 데이터베이스 설정 (30분)

### 3.1 프로덕션 데이터베이스
- **AWS RDS**: 관리형 PostgreSQL
- **Railway PostgreSQL**: 간단한 설정
- **Supabase**: 무료 PostgreSQL 제공

### 3.2 연결 설정
```properties
# application-prod.properties
spring.datasource.url=${DATABASE_URL}
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
```

---

## 4. CI/CD 파이프라인 (30분)

### 4.1 GitHub Actions
```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build
        run: npm run build
      - name: Deploy
        run: vercel --prod
```

### 4.2 자동 배포 설정
- GitHub에 푸시 시 자동 빌드 및 배포
- 테스트 통과 시에만 배포
- 환경별 배포 (개발/스테이징/프로덕션)

---

## 5. 모니터링 및 로깅 (30분)

### 5.1 로깅 설정
```java
// Logback 설정
@Configuration
public class LoggingConfig {
    // 프로덕션 환경에서 로그 레벨 조정
}
```

### 5.2 에러 추적
- **Sentry**: 에러 모니터링
- **LogRocket**: 사용자 세션 재생
- **Google Analytics**: 사용자 분석

### 5.3 성능 모니터링
- **Lighthouse**: 성능 점수 확인
- **Web Vitals**: Core Web Vitals 측정

---

## 6. 코드 리뷰 (60분)

### 6.1 코드 리뷰 체크리스트
- [ ] 코드가 읽기 쉬운가?
- [ ] 네이밍이 명확한가?
- [ ] 중복 코드가 없는가?
- [ ] 에러 처리가 적절한가?
- [ ] 보안 이슈가 없는가?
- [ ] 성능 최적화가 되어 있는가?
- [ ] 테스트가 작성되어 있는가?

### 6.2 리팩토링 포인트
- 긴 함수 분리
- 매직 넘버 상수화
- 하드코딩된 값 제거
- 주석 추가
- 타입 안정성 확보

---

## 7. 최종 프로젝트 발표 (60분)

### 7.1 발표 준비
1. **프로젝트 소개**
   - 프로젝트 목적
   - 주요 기능
   - 기술 스택

2. **시연**
   - 주요 기능 데모
   - 사용자 플로우

3. **기술적 하이라이트**
   - 어려웠던 점
   - 해결 방법
   - 배운 점

4. **향후 개선 사항**
   - 추가하고 싶은 기능
   - 개선할 부분

### 7.2 발표 자료 구성
- 프로젝트 개요
- 아키텍처 다이어그램
- 주요 기능 스크린샷
- 기술 스택
- 배포 링크

---

## 📝 오늘의 핵심 정리
1. ✅ 프로젝트 빌드 및 최적화
2. ✅ 배포 플랫폼 이해 및 배포
3. ✅ 데이터베이스 설정
4. ✅ CI/CD 파이프라인 구축
5. ✅ 코드 리뷰 및 개선
6. ✅ 최종 프로젝트 발표

## 🏠 과제
1. 프로젝트를 실제로 배포하기
2. 코드 리뷰 받기
3. 최종 프로젝트 발표 준비하기

## 📚 참고 자료
- [Vercel 공식 문서](https://vercel.com/docs)
- [Railway 공식 문서](https://docs.railway.app/)
- [Docker 공식 문서](https://docs.docker.com/)
- [GitHub Actions 문서](https://docs.github.com/en/actions)

