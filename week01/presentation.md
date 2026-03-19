# 1주차: 개발 환경 설정 및 웹 개발 기초

## 📋 학습 목표
- 개발 환경을 완전히 구축할 수 있다
- 웹 개발의 기본 개념을 이해한다
- Git/GitHub를 활용할 수 있다
- 프로젝트 구조를 이해한다

---

## 📖 비전공자를 위한 기본 용어 (강의 전 숙지)

| 용어 | 쉬운 설명 |
|------|-----------|
| **터미널** | 검은(또는 흰) 화면에 글자로 명령을 입력하는 창. 마우스 대신 키보드로 컴퓨터에게 지시하는 곳입니다. |
| **프론트엔드** | 사용자가 보는 화면. 버튼, 폼, 레이아웃 등 "눈에 보이는 부분"을 만드는 개발입니다. |
| **백엔드** | 화면 뒤에서 돌아가는 로직. 데이터 저장, 로그인 검증, API 서버 등 "보이지 않는 부분"입니다. |
| **API** | 프로그램 간 데이터를 주고받는 규칙. 식당의 "메뉴판"처럼 "이렇게 요청하면 이렇게 받을 수 있다"는 약속입니다. |
| **라이브러리** | 다른 사람이 만든 코드 모음. 우리가 가져다 쓰는 "도구 상자"라고 생각하면 됩니다. |
| **프레임워크** | 개발의 뼈대가 되는 구조. "골조"를 제공하고, 우리는 그 안을 채워 넣습니다. |

---

## 1. 개발 환경 구축 (60분)

### 1.1 Node.js 설치
- **Node.js란?**
  - **런타임 환경**: 브라우저 밖에서 JavaScript를 실행할 수 있게 해주는 환경. 원래 JavaScript는 브라우저에서만 동작했으나, Node.js 덕분에 서버, CLI 도구, 데스크톱 앱 등 다양한 곳에서 사용 가능
  - **서버 사이드 JavaScript**: 웹 서버, API 서버를 JavaScript로 구축 가능. 프론트엔드와 같은 언어로 풀스택 개발 가능
  - **npm (Node Package Manager)**: Node.js와 함께 설치되는 패키지 관리자. 라이브러리 설치(`npm install`), 프로젝트 의존성 관리, 스크립트 실행(`npm run`) 등 담당

- **💡 쉬운 비유**
  - **런타임 환경**: JavaScript는 "배우"이고, 브라우저나 Node.js는 "무대"입니다. 원래 무대가 브라우저(크롬, 사파리 등)뿐이었는데, Node.js로 서버, 터미널 도구 등 다른 무대에서도 연기할 수 있게 된 것입니다.
  - **npm**: 앱스토어처럼 "필요한 기능(패키지)"를 검색해서 설치하는 곳입니다. `npm install axios`는 "axios라는 HTTP 도구를 설치해줘"라는 의미입니다.

- **💡 비전공자를 위한 쉬운 설명**
  - **런타임 환경이란?** "코드가 실행될 수 있는 환경"이라고 생각하면 됩니다. 예를 들어, 우리말(한국어)은 한국에서만 통하듯이, 원래 JavaScript는 브라우저(Chrome, Safari 등) 안에서만 동작했습니다. Node.js는 "JavaScript를 컴퓨터에서 직접 실행할 수 있게 해주는 번역기/실행기"입니다.
  - **프론트엔드 vs 백엔드?** 프론트엔드 = 사용자가 보는 화면(웹페이지, 버튼, 폼 등). 백엔드 = 사용자가 보지 못하는 뒤쪽(서버, 데이터베이스, 비즈니스 로직). 레스토랑에 비유하면 프론트엔드는 식당 홀(손님이 앉는 곳), 백엔드는 주방입니다.
  - **npm이란?** 앱 스토어처럼 "다른 사람이 만든 코드(라이브러리)를 쉽게 설치하고 관리하는 도구"입니다. `npm install axios`라고 하면 axios라는 패키지가 설치됩니다.

- **설치 방법 (단계별 따라하기)**

  1. **다운로드**
     - 브라우저에서 https://nodejs.org/ 접속
     - **LTS**(장기 지원) 버전 다운로드 버튼 클릭 (초록색)
     - Windows: `.msi` 파일, Mac: `.pkg` 파일 다운로드됨

  2. **설치 실행**
     - Windows: 다운로드된 `.msi` 더블클릭 → Next 반복 → "Automatically install necessary tools" 체크 → 설치 완료
     - Mac: `.pkg` 더블클릭 → 계속 → 동의 → 설치 → 마침

  3. **설치 확인 (터미널 열기)**
     - Windows: `Win + R` → `cmd` 입력 → 엔터
     - Mac: `Cmd + Space` → "터미널" 또는 "Terminal" 검색 → 엔터
     - 아래 명령어 입력:
     ```bash
     node --version   # v18.x.x 또는 v20.x.x 처럼 나오면 성공
     npm --version   # 9.x.x 또는 10.x.x 처럼 나오면 성공
     ```
  4. **에러가 나면?** 터미널을 완전히 닫았다가 다시 열고, 컴퓨터를 한 번 재시작 후 다시 시도

- **권장 버전**: v18 LTS 이상

### 1.2 Java JDK 설치
- **Java란?**
  - **객체지향 프로그래밍 언어**: 코드를 객체 단위로 구조화하여 재사용성과 유지보수성을 높임
  - **Spring Boot는 Java 기반**: 백엔드 API 서버를 만들 때 Spring Boot를 사용하므로 Java 설치 필요
  - **JDK vs JRE**: JDK(개발용)는 JRE(실행용) + 컴파일러 포함. 개발에는 JDK 필요

- **💡 비전공자용 설명**
  - **컴파일이란?** 사람이 읽기 쉬운 코드(Java, C 등)를 컴퓨터가 실행할 수 있는 형태로 변환하는 과정입니다. 요리 레시피를 보고 실제 요리를 만드는 것과 비슷합니다.
  - **환경 변수란?** 컴퓨터 전체에서 "Java가 어디에 설치됐는지" 같은 정보를 저장해 두는 메모장입니다. 여러 프로그램이 이 값을 참고해서 Java를 찾습니다.

- **설치 방법 (단계별 따라하기)**

  1. **다운로드**
     - https://www.oracle.com/java/technologies/downloads/ 접속
     - 또는 (OpenJDK, 무료): https://adoptium.net/ 접속
     - **JDK 17** 또는 **JDK 21** 선택 → OS에 맞는 설치 파일 다운로드
     - Windows: `.exe` 또는 `.msi`, Mac: `.pkg` 또는 `.dmg`

  2. **설치**
     - Windows: 설치 파일 실행 → Next → 경로 확인(기본: `C:\Program Files\Java\jdk-17`) → 설치
     - Mac: `.pkg` 실행 → 계속 → 동의 → 설치 → 설치 경로 확인 (보통 `/Library/Java/JavaVirtualMachines/`)

  3. **환경 변수 설정 (필수)**
     - **Windows**:
       1. "환경 변수" 검색 → "시스템 환경 변수 편집" 클릭
       2. "환경 변수" 버튼 클릭
       3. "새로 만들기" → 변수 이름: `JAVA_HOME` / 변수 값: `C:\Program Files\Java\jdk-17` (설치 경로)
       4. "Path" 선택 → 편집 → 새로 만들기 → `%JAVA_HOME%\bin` 추가 → 확인
     - **Mac**:
       - `java -version`이 바로 된다면 보통 별도 설정 불필요 (macOS는 자동 설정되는 경우 많음)
       - **안 되면**:
         1. 터미널 열기 (`Cmd + Space` → "터미널" 입력)
         2. `nano ~/.zshrc` (또는 `nano ~/.bash_profile`) 실행
         3. 아래 두 줄 추가 후 `Ctrl+O` 저장 → `Ctrl+X` 종료
            ```
            export JAVA_HOME=$(/usr/libexec/java_home)
            export PATH=$JAVA_HOME/bin:$PATH
            ```
         4. 터미널 다시 열거나 `source ~/.zshrc` 실행

  4. **설치 확인**
     ```bash
     java -version   # java version "17.x.x" 등 출력
     javac -version  # javac 17.x.x 등 출력
     ```

- **권장 버전**: JDK 17 이상

### 1.3 IDE 설치 및 설정

- **VS Code** (프론트엔드 개발)

  **설치 방법**
  1. https://code.visualstudio.com/ 접속
  2. "Download for Windows" 또는 "Download for macOS" 클릭
  3. 설치 파일 실행 → 설치 (기본 옵션 그대로 진행)
  4. VS Code 실행

  **확장 프로그램 설치 (필수)**
  1. 왼쪽 사이드바에서 **확장(Extensions)** 아이콘 클릭 (또는 `Ctrl+Shift+X` / `Cmd+Shift+X`)
  2. 검색창에 이름 입력 후 **설치(Install)** 클릭:
     - `ES7+ React/Redux/React-Native snippets` → React 코드 자동 완성
     - `Prettier` → 코드 자동 포맷팅
     - `ESLint` → 코드 오류/스타일 검사
     - `GitLens` → Git 히스토리, 변경 이력 표시
  3. 설치 완료 후 "다시 로드" 버튼 있으면 클릭

- **IntelliJ IDEA** (백엔드 개발)

  **설치 방법**
  1. https://www.jetbrains.com/idea/download/ 접속
  2. **Community** 버전 선택 (무료) → 다운로드
  3. 설치 실행 → 기본 옵션으로 설치
  4. IntelliJ 실행

  **Spring Boot 플러그인**
  1. File → Settings (또는 `Ctrl+Alt+S` / `Cmd+,`)
  2. Plugins → "Spring Boot" 검색 → **Spring Boot** 플러그인 설치
  3. 재시작

### 1.4 Git 설치 및 설정
- **Git이란?**
  - 분산 버전 관리 시스템으로, 코드의 변경 이력을 추적하고 협업할 수 있게 해줌
  - "버전 관리" = 파일의 추가·수정·삭제 이력을 저장하고, 필요 시 이전 버전으로 되돌릴 수 있음
  - "분산" = 여러 사람이 각자의 로컬에서 작업하며, 나중에 원격 저장소와 동기화

- **💡 Git을 워드 '되돌리기'로 생각해보세요**
  - 워드에서 Ctrl+Z로 되돌리듯, Git은 "저장 시점"마다 스냅샷을 찍어둡니다.
  - 차이점: Git은 "왜 수정했는지" 메시지(커밋 메시지)를 함께 저장하고, 여러 버전을 가지(브랜치)로 나눌 수 있습니다.
  - **커밋** = "이 시점을 저장" 버튼을 누른 것. **푸시** = 이 컴퓨터의 저장 이력을 GitHub(클라우드)에 올리는 것.

- **Git 설치 방법 (단계별 따라하기)**

  1. **다운로드**
     - https://git-scm.com/downloads 접속
     - Windows: "Click here to download" 클릭 → `.exe` 다운로드
     - Mac: "Download for macOS" 클릭 → `.dmg` 다운로드, 또는 터미널에서 `xcode-select --install` (Apple 개발 도구에 포함)

  2. **설치**
     - Windows: `.exe` 실행 → Next 반복 (기본값 유지, "Git from the command line and also from 3rd-party software" 선택 권장)
     - Mac (방법 1): `.dmg` 더블클릭 → 설치 프로그램 실행 → 계속 → 설치
     - Mac (방법 2): 터미널 열기 → `xcode-select --install` 입력 → "설치" 클릭 → 완료 후 `git --version` 확인

  3. **사용자 정보 설정 (최초 1회, 필수)**
     - 터미널 열기
     - 아래 명령어에서 `"Your Name"`을 본인 이름, `your.email@example.com`을 본인 이메일로 바꿔서 실행:
     ```bash
     git config --global user.name "Your Name"
     git config --global user.email "your.email@example.com"
     ```

  4. **설치 확인**
     ```bash
     git --version   # git version 2.x.x 등 출력되면 성공
     ```

---

## 2. 웹 개발 기초 개념 (90분)

### 2.1 웹의 동작 원리
- **클라이언트-서버 모델**
  - **클라이언트**: 사용자가 사용하는 브라우저. 사용자 요청을 생성하고 서버 응답을 화면에 표시
  - **서버**: 요청을 받아 처리하고 응답을 반환하는 프로그램. 데이터 저장, 비즈니스 로직 처리 담당
  - **요청-응답 흐름**: 사용자가 URL을 입력하거나 링크를 클릭 → 브라우저가 HTTP 요청 전송 → 서버가 처리 후 응답 반환 → 브라우저가 HTML/CSS/JS로 화면 렌더링

- **💡 쉬운 비유: 레스토랑으로 생각해보세요**
  - **클라이언트(손님)**: 브라우저 = 손님. "김치찌개 주세요"라고 주문(요청)합니다.
  - **서버(점원+주방)**: 웹 서버 = 점원+주방. 주문을 받아 처리하고 요리를 내옵니다(응답).
  - **HTTP**: 손님과 점원이 주고받는 "말(규칙)". "주문" "영수증" "환불 요청" 같은 것들이 메시지 종류(GET, POST 등)입니다.
  ```
  브라우저(클라이언트) → HTTP 요청 → 서버
  브라우저(클라이언트) ← HTTP 응답 ← 서버
  ```

- **HTTP 프로토콜**
  - 웹에서 데이터를 주고받기 위한 표준 규약. **Stateless(무상태)**: 서버는 각 요청을 독립적으로 처리하며, 이전 요청 정보를 저장하지 않음 (세션/쿠키로 보완)
  - **GET**: 데이터 조회. URL에 파라미터 포함 가능. 캐싱 가능
  - **POST**: 데이터 생성. 요청 본문에 데이터 포함. 부수 효과 있음
  - **PUT**: 리소스 전체 수정
  - **DELETE**: 리소스 삭제

- **💡 Stateless(무상태)를 쉽게 말하면**
  - 서버는 "이전에 손님이 뭘 먹었는지" 기억하지 않습니다. 매번 "주문하시겠어요?"부터 다시 시작합니다.
  - 그래서 로그인처럼 "이 사람이 누구인지" 기억하려면 쿠키/세션/JWT 같은 별도 방식을 씁니다.
  - 장점: 서버가 단순해지고, 사용자 수가 늘어나도 서버를 쉽게 늘릴 수 있습니다.

### 2.2 HTML 기초
```html
<!DOCTYPE html>
<html>
<head>
    <title>My First Web Page</title>
</head>
<body>
    <h1>Hello World</h1>
    <p>This is a paragraph.</p>
</body>
</html>
```

- **💡 HTML 쉽게 이해하기**
  - HTML = 웹페이지의 **뼈대**. "여기는 제목", "여기는 문단", "여기는 이미지"처럼 구조를 정의
  - 태그는 `<이름>`으로 시작하고 `</이름>`으로 닫음. 마치 꺾쇠괄호로 감싸진 '레이블'처럼 생각하면 됨
  - **흔한 실수**: 태그를 닫지 않거나, 중첩 순서를 잘못 넣음 (예: `<p><strong>텍스트</p></strong>` ❌)

- **주요 태그**
  - `<div>`, `<span>`: 컨테이너
  - `<h1>` ~ `<h6>`: 제목
  - `<p>`: 문단
  - `<a>`: 링크
  - `<img>`: 이미지
  - `<input>`: 입력 필드
  - `<button>`: 버튼

- **💡 div vs span (처음에 헷갈리기 쉬운 부분)**
  - **`<div>`**: 한 줄 전체를 차지하는 "박스". 블록처럼 위아래로 쌓입니다. 레이아웃의 큰 구역을 나눌 때 씁니다.
  - **`<span>`**: 글자 일부만 감싸는 "테이프". 같은 줄 안에서 특정 텍스트만 스타일을 줄 때 씁니다.
  - 예: "이 단어만 빨간색" → `<span style="color:red">이 단어만</span> 빨간색

### 2.3 CSS 기초
```css
/* 선택자 */
h1 {
    color: blue;
    font-size: 24px;
}

.class-name {
    background-color: #f0f0f0;
}

#id-name {
    margin: 10px;
}
```

- **💡 CSS 쉽게 이해하기**
  - CSS = 웹페이지의 **꾸밈**. 색, 크기, 여백, 폰트 등을 지정
  - **선택자**: "누구에게" 스타일을 적용할지 지정. `h1`은 모든 제목, `.클래스명`은 그 클래스를 가진 요소, `#아이디`는 그 id를 가진 요소
  - **박스 모델**: 모든 요소는 상자처럼 생각. Content(내용) → Padding(안쪽 여백) → Border(테두리) → Margin(바깥 여백) 순으로 감싸져 있음

- **주요 개념**
  - 선택자 (Selector)
  - 속성 (Property)
  - 값 (Value)
  - 박스 모델 (Margin, Padding, Border)

- **💡 박스 모델을 손으로 그려보면**
  - 내용(Content) → 가장 안쪽, 글자·이미지가 들어가는 공간
  - Padding → 내용과 테두리 사이의 "안쪽 여백" (양탄자와 그림 프레임 사이)
  - Border → 테두리 (프레임)
  - Margin → 박스 바깥의 "바깥쪽 여백" (벽과 액자 사이)
  - 순서: 바깥에서 안으로 Margin → Border → Padding → Content

### 2.4 JavaScript 기초
```javascript
// 변수 선언
let name = "John";
const age = 25;

// 함수
function greet(name) {
    return `Hello, ${name}!`;
}

// 화살표 함수
const greetArrow = (name) => `Hello, ${name}!`;

// 배열
const fruits = ["apple", "banana", "orange"];

// 객체
const person = {
    name: "John",
    age: 25,
    greet: function() {
        return `Hello, I'm ${this.name}`;
    }
};
```

- **ES6+ 주요 기능**
  - let, const
  - 화살표 함수
  - 템플릿 리터럴
  - 구조 분해 할당
  - Promise, async/await

---

## 3. Git/GitHub 기초 (60분)

- **💡 Git 쉽게 이해하기**
  - **비유**: Git = "워드의 되돌리기"를 강화한 것. 어제 버전, 그저께 버전, 1주 전 버전으로 언제든 돌아갈 수 있음
  - **커밋**: "이 시점을 저장해둘게" 하는 것. 스냅샷을 찍는 것과 비슷
  - **흔한 실수**: `git add`를 안 하고 `git commit`만 하면 "파일이 없다"고 나옴. 변경 사항은 반드시 `add`로 스테이징한 뒤 `commit`해야 함

### 3.1 Git 기본 명령어
```bash
# 저장소 초기화
git init

# 파일 추가
git add .

# 커밋
git commit -m "Initial commit"

# 상태 확인
git status

# 변경 이력 확인
git log
```

### 3.2 GitHub 사용법
```bash
# 원격 저장소 추가
git remote add origin https://github.com/username/repo.git

# 푸시
git push -u origin main

# 풀
git pull origin main

# 클론
git clone https://github.com/username/repo.git
```

### 3.3 브랜치 관리
- **브랜치란?** 메인 코드(main)에서 분기된 독립적인 작업 공간
- **왜 사용하나?** 기능 개발, 버그 수정을 메인 코드와 분리하여 작업한 뒤, 완료 시 병합
- **일반적인 워크플로우**: main → feature 브랜치 생성 → 작업 → main에 병합

```bash
# 브랜치 생성 및 이동
git checkout -b feature/new-feature

# 브랜치 목록
git branch

# 브랜치 병합
git merge feature/new-feature
```

---

## 4. 프로젝트 구조 이해 (30분)

### 4.1 프론트엔드 프로젝트 구조
- **components/**: 재사용 가능한 UI 조각 (버튼, 카드, 모달 등)
- **pages/**: 화면 단위 컴포넌트 (홈, 로그인, 대시보드 등)
- **utils/**: 공통 유틸 함수 (날짜 포맷팅, API 호출 등)

```
frontend/
├── public/
│   └── index.html
├── src/
│   ├── components/
│   ├── pages/
│   ├── utils/
│   ├── App.js
│   └── index.js
├── package.json
└── README.md
```

### 4.2 백엔드 프로젝트 구조
- **controller/**: HTTP 요청을 받아 서비스에 전달하고 응답 반환
- **service/**: 비즈니스 로직 처리 (예: 할일 생성, 수정, 삭제 규칙)
- **repository/**: 데이터베이스 접근 (CRUD)
- **entity/**: 데이터베이스 테이블과 매핑되는 Java 클래스

```
backend/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/
│   │   │       ├── controller/
│   │   │       ├── service/
│   │   │       ├── repository/
│   │   │       └── entity/
│   │   └── resources/
│   │       └── application.properties
│   └── test/
├── pom.xml (Maven) 또는 build.gradle (Gradle)
└── README.md
```

---

## 5. 실습: 첫 번째 프로젝트 생성 (30분)

### 5.1 React 프로젝트 생성
```bash
# Create React App 사용
npx create-react-app my-first-app
cd my-first-app
npm start
```

### 5.2 Spring Boot 프로젝트 생성
- Spring Initializr 사용
- https://start.spring.io/
- 의존성: Spring Web, Spring Data JPA, PostgreSQL Driver

### 5.3 GitHub에 업로드
```bash
git init
git add .
git commit -m "Initial project setup"
git remote add origin [your-repo-url]
git push -u origin main
```

---

## 📝 오늘의 핵심 정리
1. ✅ 개발 환경 구축 완료
2. ✅ 웹 개발 기본 개념 이해
3. ✅ Git/GitHub 사용법 습득
4. ✅ 프로젝트 구조 이해

## 🏠 과제
1. 개인 GitHub 계정 생성 및 첫 저장소 만들기
2. 간단한 HTML/CSS/JavaScript 페이지 만들기
3. 다음 주차 준비: React 공식 문서 읽어오기

## 📚 참고 자료
- [Node.js 공식 문서](https://nodejs.org/)
- [Java 공식 문서](https://www.oracle.com/java/)
- [Git 공식 문서](https://git-scm.com/)
- [MDN Web Docs](https://developer.mozilla.org/)

