# 1주차 실습 문제

## 실습 1: 개발 환경 확인 (10분)

### 목표
개발 환경이 제대로 설치되었는지 확인합니다.

### 문제
다음 명령어들을 실행하고 결과를 확인하세요:

```bash
# 1. Node.js 버전 확인
node --version

# 2. npm 버전 확인
npm --version

# 3. Java 버전 확인
java -version

# 4. Git 버전 확인
git --version
```

### 제출물
각 명령어의 출력 결과를 스크린샷으로 제출하세요.

---

## 실습 2: 간단한 HTML 페이지 만들기 (30분)

### 목표
HTML, CSS, JavaScript를 사용하여 간단한 웹 페이지를 만듭니다.

### 문제
다음 요구사항을 만족하는 웹 페이지를 만드세요:

1. **HTML 구조**
   - 제목: "나의 첫 번째 웹 페이지"
   - 자기소개 섹션 (이름, 나이, 취미)
   - 버튼: "클릭하세요"

2. **CSS 스타일링**
   - 배경색: #f0f0f0
   - 제목: 중앙 정렬, 파란색
   - 자기소개: 카드 형태로 디자인

3. **JavaScript 기능**
   - 버튼 클릭 시 알림창 표시
   - 현재 시간을 콘솔에 출력

### 예시 코드 구조
```html
<!DOCTYPE html>
<html>
<head>
    <title>실습 2</title>
    <style>
        /* CSS 작성 */
    </style>
</head>
<body>
    <!-- HTML 작성 -->
    <script>
        // JavaScript 작성
    </script>
</body>
</html>
```

### 제출물
- HTML 파일 (index.html)
- 스크린샷 (브라우저에서 실행한 모습)

---

## 실습 3: Git 저장소 만들기 (20분)

### 목표
GitHub에 저장소를 만들고 첫 커밋을 합니다.

### 문제
다음 단계를 따라하세요:

1. **GitHub에서 저장소 생성**
   - Repository name: `likelion-study-week01`
   - Public으로 설정
   - README.md 추가하지 않기

2. **로컬에서 Git 초기화**
   ```bash
   git init
   git add .
   git commit -m "Initial commit: Week 1 exercises"
   ```

3. **원격 저장소 연결 및 푸시**
   ```bash
   git remote add origin [your-repo-url]
   git branch -M main
   git push -u origin main
   ```

4. **README.md 작성**
   - 프로젝트 설명
   - 설치 방법
   - 실행 방법

### 제출물
- GitHub 저장소 URL
- README.md 내용

---

## 실습 4: React 프로젝트 생성 및 실행 (20분)

### 목표
Create React App을 사용하여 첫 React 프로젝트를 만듭니다.

### 문제
다음 단계를 따라하세요:

1. **프로젝트 생성**
   ```bash
   npx create-react-app my-first-react-app
   cd my-first-react-app
   ```

2. **프로젝트 실행**
   ```bash
   npm start
   ```

3. **코드 수정**
   - `src/App.js` 파일을 열어보기
   - "Hello World" 텍스트를 "안녕하세요, 리액트!"로 변경
   - 브라우저에서 변경사항 확인

4. **프로젝트 구조 이해**
   - 각 폴더와 파일의 역할 파악
   - `package.json` 파일 확인

### 제출물
- 수정된 App.js 코드
- 브라우저에서 실행된 화면 스크린샷

---

## 실습 5: Spring Boot 프로젝트 생성 (20분)

### 목표
Spring Initializr를 사용하여 첫 Spring Boot 프로젝트를 만듭니다.

### 문제
다음 단계를 따라하세요:

1. **Spring Initializr 접속**
   - https://start.spring.io/

2. **프로젝트 설정**
   - Project: Maven
   - Language: Java
   - Spring Boot: 3.1.x
   - Group: com.likelion
   - Artifact: my-first-spring-app
   - Dependencies: Spring Web

3. **프로젝트 다운로드 및 압축 해제**

4. **프로젝트 실행**
   ```bash
   cd my-first-spring-app
   ./mvnw spring-boot:run
   # 또는 Windows: mvnw.cmd spring-boot:run
   ```

5. **간단한 컨트롤러 추가**
   - `src/main/java/com/likelion/controller/HelloController.java` 생성
   - "/hello" 엔드포인트 만들기

### 예시 코드
```java
package com.likelion.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    
    @GetMapping("/hello")
    public String hello() {
        return "안녕하세요, Spring Boot!";
    }
}
```

### 제출물
- 생성된 프로젝트 구조 스크린샷
- HelloController.java 코드
- 브라우저에서 http://localhost:8080/hello 접속한 결과

---

## 종합 실습: 개인 포트폴리오 페이지 (선택사항)

### 목표
지금까지 배운 내용을 종합하여 개인 포트폴리오 페이지를 만듭니다.

### 요구사항
1. HTML, CSS, JavaScript 사용
2. 반응형 디자인 (모바일 친화적)
3. GitHub에 업로드
4. GitHub Pages로 배포 (선택사항)

### 포함할 내용
- 자기소개
- 기술 스택
- 프로젝트 소개
- 연락처 정보

### 제출물
- GitHub 저장소 URL
- 배포된 페이지 URL (GitHub Pages 사용 시)

---

## 평가 기준

| 실습 | 배점 | 평가 기준 |
|------|------|-----------|
| 실습 1 | 10점 | 모든 명령어 정상 실행 |
| 실습 2 | 25점 | HTML/CSS/JS 정상 작동 |
| 실습 3 | 20점 | Git 저장소 정상 생성 및 푸시 |
| 실습 4 | 20점 | React 프로젝트 정상 실행 |
| 실습 5 | 25점 | Spring Boot 프로젝트 정상 실행 |
| 종합 실습 | 보너스 | 추가 점수 |

**총점: 100점**

---

## 제출 방법
1. 각 실습의 제출물을 개인 GitHub 저장소에 업로드
2. 저장소 URL을 제출
3. README.md에 각 실습별 설명 추가

