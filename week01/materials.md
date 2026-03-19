# 1주차 보조 자료

## 개발 환경 설치 가이드

### macOS 설치 가이드

#### Node.js 설치
```bash
# Homebrew 사용
brew install node

# 또는 공식 사이트에서 다운로드
# https://nodejs.org/
```

#### Java 설치
```bash
# Homebrew 사용
brew install openjdk@17

# 환경 변수 설정 (~/.zshrc 또는 ~/.bash_profile)
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$JAVA_HOME/bin:$PATH
```

### Windows 설치 가이드

#### Node.js 설치
1. https://nodejs.org/ 접속
2. LTS 버전 다운로드 및 설치
3. 설치 확인: `node --version`

#### Java 설치
1. https://adoptium.net/ 접속
2. JDK 17 다운로드 및 설치
3. 환경 변수 설정:
   - 시스템 속성 → 고급 → 환경 변수
   - JAVA_HOME 설정
   - PATH에 %JAVA_HOME%\bin 추가

## Git 설정 상세

### SSH 키 생성 및 GitHub 연결
```bash
# SSH 키 생성
ssh-keygen -t ed25519 -C "your_email@example.com"

# 공개 키 복사 (macOS)
pbcopy < ~/.ssh/id_ed25519.pub

# 공개 키 복사 (Windows)
cat ~/.ssh/id_ed25519.pub
# 출력된 내용을 복사

# GitHub에 SSH 키 추가
# Settings → SSH and GPG keys → New SSH key
```

## 웹 개발 기초 개념 정리

### HTML 시맨틱 태그
```html
<header>헤더 영역</header>
<nav>네비게이션</nav>
<main>메인 콘텐츠</main>
<section>섹션</section>
<article>독립적인 콘텐츠</article>
<aside>사이드바</aside>
<footer>푸터</footer>
```

### CSS Flexbox 기초
```css
.container {
    display: flex;
    justify-content: center; /* 가로 정렬 */
    align-items: center; /* 세로 정렬 */
    flex-direction: column; /* 방향 */
}
```

### JavaScript 비동기 처리
```javascript
// Promise
fetch('/api/data')
    .then(response => response.json())
    .then(data => console.log(data))
    .catch(error => console.error(error));

// async/await
async function fetchData() {
    try {
        const response = await fetch('/api/data');
        const data = await response.json();
        console.log(data);
    } catch (error) {
        console.error(error);
    }
}
```

## 프로젝트 구조 설명

### package.json (Node.js)
```json
{
  "name": "my-app",
  "version": "1.0.0",
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build"
  }
}
```

### application.properties (Spring Boot)
```properties
# 서버 포트
server.port=8080

# 데이터베이스 설정
spring.datasource.url=jdbc:postgresql://localhost:5432/mydb
spring.datasource.username=postgres
spring.datasource.password=password

# JPA 설정
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

## 자주 사용하는 명령어 모음

### npm 명령어
```bash
npm install          # 패키지 설치
npm install react    # 특정 패키지 설치
npm start            # 개발 서버 실행
npm run build        # 프로덕션 빌드
npm test             # 테스트 실행
```

### Git 명령어
```bash
git status           # 상태 확인
git add .            # 모든 변경사항 스테이징
git commit -m "msg"  # 커밋
git push             # 원격 저장소에 푸시
git pull             # 원격 저장소에서 가져오기
git clone url        # 저장소 클론
```

### Maven 명령어 (Spring Boot)
```bash
./mvnw spring-boot:run    # 애플리케이션 실행
./mvnw clean package      # 빌드
./mvnw test               # 테스트 실행
```

## 문제 해결 가이드

### Node.js 버전 문제
```bash
# nvm 사용 (Node Version Manager)
nvm install 18
nvm use 18
```

### 포트 충돌 문제
```bash
# 포트 사용 중인 프로세스 확인 (macOS/Linux)
lsof -i :3000

# 프로세스 종료
kill -9 [PID]

# Windows
netstat -ano | findstr :3000
taskkill /PID [PID] /F
```

### Git 인증 문제
```bash
# Personal Access Token 사용
# GitHub → Settings → Developer settings → Personal access tokens
```

