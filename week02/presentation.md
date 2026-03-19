# 2주차: React 기초

## 📋 학습 목표
- React의 개념과 장점을 이해한다
- JSX 문법을 사용할 수 있다
- 컴포넌트를 만들고 사용할 수 있다
- Props와 State를 이해하고 활용한다
- 이벤트를 처리할 수 있다

---

## 💡 비전공자를 위한 한눈에 보기

- **React**: 웹 화면(UI)을 만드는 JavaScript 라이브러리. 인스타그램, 넷플릭스, 페이스북 등에서 사용
- **컴포넌트**: 화면을 레고 블록처럼 나눈 조각. 버튼, 카드, 헤더를 각각 컴포넌트로 만들고 조합
- **Props**: 부모가 자식에게 넘겨주는 "재료". 예: `<버튼 텍스트="저장" />`에서 "저장"이 props
- **State**: 컴포넌트 안에서 바뀌는 값. 예: 카운터 숫자, 입력한 글자, 모달 열림 여부. 바뀌면 화면이 다시 그려짐

---

## 1. React 소개 (30분)

### 1.1 React란?
- **정의**: 사용자 인터페이스를 구축하기 위한 JavaScript 라이브러리
- **개발사**: Facebook (Meta) - 2013년 공개, 현재 Meta에서 유지보수
- **특징**:
  - **컴포넌트 기반 개발**: UI를 레고 블록처럼 독립적인 조각으로 나누어 조합
  - **가상 DOM (Virtual DOM)**: 실제 DOM을 직접 조작하지 않고 메모리 상의 가벼운 복사본으로 변경 사항을 비교 후 최소한만 실제 DOM에 반영하여 성능 최적화
  - **단방향 데이터 흐름**: 데이터가 부모 → 자식으로만 흐르며, 예측 가능한 상태 관리 가능
  - **재사용 가능한 UI 컴포넌트**: 한 번 만든 컴포넌트를 다양한 화면에서 활용

### 1.2 React의 장점
- **컴포넌트 재사용성**: 한 번 만든 컴포넌트를 여러 곳에서 사용하여 개발 효율 향상
- **가상 DOM**: 실제 DOM 조작은 비용이 크므로, React는 변경된 부분만 계산해서 최소한으로 업데이트
- **풍부한 생태계**: npm에 40만 개 이상의 React 관련 패키지, 다양한 UI 라이브러리
- **커뮤니티**: 전 세계 가장 많이 사용되는 프론트엔드 라이브러리로, 질문·해결이 빠름

### 1.3 React vs Vanilla JavaScript
```javascript
// Vanilla JavaScript
const button = document.createElement('button');
button.textContent = 'Click me';
button.addEventListener('click', () => {
    alert('Clicked!');
});
document.body.appendChild(button);

// React
function Button() {
    return (
        <button onClick={() => alert('Clicked!')}>
            Click me
        </button>
    );
}
```

---

## 2. JSX 문법 (60분)

### 2.1 JSX란?
- **정의**: JavaScript XML - JavaScript 코드 안에 HTML과 유사한 문법을 작성할 수 있게 하는 확장 문법
- **특징**: 
  - 내부적으로 `React.createElement()`로 변환되는 **문법적 설탕(Syntactic Sugar)**으로, 개발자가 더 직관적으로 UI를 작성 가능
  - Babel 등의 트랜스파일러가 JSX를 일반 JavaScript로 변환한 후 브라우저에서 실행

### 2.2 JSX 기본 문법
```jsx
// 기본 구조
const element = <h1>Hello, World!</h1>;

// JavaScript 표현식 사용
const name = "John";
const element = <h1>Hello, {name}!</h1>;

// 속성 사용
const element = <img src="image.jpg" alt="Description" />;

// 클래스명 (className 사용 - class는 JavaScript 예약어이므로 className 사용)
const element = <div className="container">Content</div>;

// 인라인 스타일 (객체로 전달 - camelCase로 작성, 문자열이 아닌 숫자/객체)
const element = <div style={{ color: 'red', fontSize: '20px' }}>Text</div>;
```

### 2.3 JSX 규칙
1. **하나의 부모 요소**: 반드시 하나의 최상위 요소로 감싸야 함
```jsx
// ❌ 잘못된 예
return (
    <h1>Title</h1>
    <p>Content</p>
);

// ✅ 올바른 예
return (
    <div>
        <h1>Title</h1>
        <p>Content</p>
    </div>
);
```

2. **Fragment 사용**: 불필요한 div를 피하고 싶을 때
```jsx
return (
    <>
        <h1>Title</h1>
        <p>Content</p>
    </>
);
```

3. **자기 닫는 태그**: 모든 태그는 닫아야 함
```jsx
// ✅ 올바른 예
<img src="..." alt="..." />
<br />
<input type="text" />
```

---

## 3. 컴포넌트 기초 (90분)

### 3.1 컴포넌트란?
- **정의**: UI를 독립적이고 재사용 가능한 조각으로 나눈 것
- **종류**:
  - 함수형 컴포넌트 (Function Component) - 권장
  - 클래스형 컴포넌트 (Class Component) - 레거시

### 3.2 함수형 컴포넌트
```jsx
// 기본 형태
function Welcome() {
    return <h1>Hello, World!</h1>;
}

// 화살표 함수
const Welcome = () => {
    return <h1>Hello, World!</h1>;
};

// 간단한 경우 중괄호 생략 가능
const Welcome = () => <h1>Hello, World!</h1>;
```

### 3.3 컴포넌트 사용
```jsx
// 컴포넌트 정의
function Welcome() {
    return <h1>Welcome!</h1>;
}

// 컴포넌트 사용
function App() {
    return (
        <div>
            <Welcome />
            <Welcome />
            <Welcome />
        </div>
    );
}
```

### 3.4 컴포넌트 분리
```jsx
// Header.js
function Header() {
    return <header><h1>My App</h1></header>;
}

// Footer.js
function Footer() {
    return <footer><p>Copyright 2024</p></footer>;
}

// App.js
import Header from './Header';
import Footer from './Footer';

function App() {
    return (
        <div>
            <Header />
            <main>Content</main>
            <Footer />
        </div>
    );
}
```

---

## 4. Props (60분)

### 4.1 Props란?
- **정의**: Properties의 약자 - 부모 컴포넌트에서 자식 컴포넌트로 데이터를 전달하는 방법
- **특징**: 
  - **읽기 전용(immutable)**: 자식 컴포넌트에서 props를 수정하면 안 됨. React의 단방향 데이터 흐름 원칙
  - **언제 사용?**: 부모가 자식에게 "이 데이터로 화면을 그려줘"라고 전달할 때

### 4.2 Props 사용하기
```jsx
// 부모 컴포넌트
function App() {
    return (
        <div>
            <Greeting name="John" age={25} />
            <Greeting name="Jane" age={30} />
        </div>
    );
}

// 자식 컴포넌트
function Greeting(props) {
    return (
        <div>
            <h1>Hello, {props.name}!</h1>
            <p>You are {props.age} years old.</p>
        </div>
    );
}
```

### 4.3 구조 분해 할당
```jsx
// 방법 1: 함수 매개변수에서 구조 분해
function Greeting({ name, age }) {
    return (
        <div>
            <h1>Hello, {name}!</h1>
            <p>You are {age} years old.</p>
        </div>
    );
}

// 방법 2: 함수 내부에서 구조 분해
function Greeting(props) {
    const { name, age } = props;
    return (
        <div>
            <h1>Hello, {name}!</h1>
            <p>You are {age} years old.</p>
        </div>
    );
}
```

### 4.4 기본값 설정
```jsx
function Greeting({ name = "Guest", age = 0 }) {
    return (
        <div>
            <h1>Hello, {name}!</h1>
            <p>You are {age} years old.</p>
        </div>
    );
}
```

### 4.5 children Props
```jsx
function Card({ children }) {
    return (
        <div className="card">
            {children}
        </div>
    );
}

function App() {
    return (
        <Card>
            <h2>Title</h2>
            <p>Content</p>
        </Card>
    );
}
```

---

## 5. State (90분)

### 5.1 State란?
- **정의**: 컴포넌트 내부에서 변경 가능한 데이터 (사용자 입력, 클릭 횟수, 모달 열림 여부 등)
- **Props vs State**: Props는 부모가 전달하는 데이터, State는 컴포넌트 자신이 관리하는 데이터
- **특징**: 
  - State가 변경되면 React가 해당 컴포넌트를 **다시 렌더링**하여 화면을 갱신
  - `useState` Hook을 사용하여 선언하고, setter 함수로만 업데이트해야 함 (직접 수정 금지)

### 5.2 useState Hook
```jsx
import { useState } from 'react';

function Counter() {
    // useState 사용법
    // const [상태값, 상태변경함수] = useState(초기값);
    const [count, setCount] = useState(0);
    
    return (
        <div>
            <p>Count: {count}</p>
            <button onClick={() => setCount(count + 1)}>
                Increase
            </button>
        </div>
    );
}
```

### 5.3 State 업데이트
```jsx
function Counter() {
    const [count, setCount] = useState(0);
    
    // 직접 증가
    const handleIncrease = () => {
        setCount(count + 1);
    };
    
    // 함수형 업데이트 (이전 값 사용) - 비동기 환경에서 정확한 값 보장
    const handleIncrease = () => {
        setCount(prevCount => prevCount + 1);
    };
    // 주의: setCount(count + 1)을 연속 호출하면 이전 count를 기준으로 동작해 한 번만 증가할 수 있음
    
    return (
        <div>
            <p>Count: {count}</p>
            <button onClick={handleIncrease}>Increase</button>
        </div>
    );
}
```

### 5.4 여러 State 사용
```jsx
function Form() {
    const [name, setName] = useState('');
    const [email, setEmail] = useState('');
    const [age, setAge] = useState(0);
    
    return (
        <form>
            <input 
                type="text" 
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Name"
            />
            <input 
                type="email" 
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="Email"
            />
            <input 
                type="number" 
                value={age}
                onChange={(e) => setAge(Number(e.target.value))}
                placeholder="Age"
            />
        </form>
    );
}
```

### 5.5 객체 State
```jsx
function UserProfile() {
    const [user, setUser] = useState({
        name: '',
        email: '',
        age: 0
    });
    
    const handleChange = (field, value) => {
        setUser({
            ...user,  // 기존 값 복사
            [field]: value  // 특정 필드만 업데이트
        });
    };
    
    return (
        <div>
            <input 
                value={user.name}
                onChange={(e) => handleChange('name', e.target.value)}
            />
            <input 
                value={user.email}
                onChange={(e) => handleChange('email', e.target.value)}
            />
        </div>
    );
}
```

---

## 6. 이벤트 처리 (60분)

### 6.1 이벤트 핸들러
```jsx
function Button() {
    const handleClick = () => {
        alert('Button clicked!');
    };
    
    return <button onClick={handleClick}>Click me</button>;
}
```

### 6.2 인라인 이벤트 핸들러
```jsx
function Button() {
    return (
        <button onClick={() => alert('Clicked!')}>
            Click me
        </button>
    );
}
```

### 6.3 이벤트 객체
```jsx
function Input() {
    const handleChange = (e) => {
        console.log('Value:', e.target.value);
    };
    
    return <input onChange={handleChange} />;
}
```

### 6.4 주요 이벤트
- `onClick`: 클릭 이벤트
- `onChange`: 입력값 변경
- `onSubmit`: 폼 제출
- `onFocus`: 포커스 받을 때
- `onBlur`: 포커스 잃을 때
- `onMouseEnter`: 마우스 진입
- `onMouseLeave`: 마우스 벗어남

### 6.5 폼 처리
```jsx
function LoginForm() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    
    const handleSubmit = (e) => {
        e.preventDefault();  // 기본 동작 방지
        console.log('Email:', email);
        console.log('Password:', password);
    };
    
    return (
        <form onSubmit={handleSubmit}>
            <input 
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="Email"
            />
            <input 
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Password"
            />
            <button type="submit">Login</button>
        </form>
    );
}
```

---

## 6.5 React 프로젝트 생성 - 따라하기 (비전공자용)

> **💡 Create React App이란?** React 프로젝트를 한 번에 만들어 주는 도구. "빈 프로젝트 템플릿 + 필요한 설정"을 자동으로 세팅해 줍니다.

### 단계별 설치 및 실행

**1단계: 터미널 열기**
- Windows: `Win + R` → `cmd` 입력 후 엔터
- Mac: `Spotlight(Cmd + Space)` → "터미널" 입력
- VS Code: 터미널 메뉴 → 새 터미널 (Ctrl+` 또는 Cmd+`)

**2단계: 프로젝트 생성할 폴더로 이동**
```bash
cd Desktop    # 바탕화면으로 이동 (원하는 경로로 변경 가능)
```

**3단계: Create React App 실행**
```bash
npx create-react-app my-first-app
```
- `npx`: npm 패키지를 설치 없이 한 번만 실행할 때 사용
- `my-first-app`은 원하는 폴더 이름으로 변경 가능 (영문, 소문자, 공백 없음 권장)
- 완료까지 2~5분 소요 (인터넷 필요)

**4단계: 프로젝트 폴더로 이동**
```bash
cd my-first-app
```

**5단계: 개발 서버 실행**
```bash
npm start
```
- 브라우저가 자동으로 `http://localhost:3000` 열림
- 수정하면 화면이 자동으로 갱신됨 (Hot Reload)
- 종료: 터미널에서 `Ctrl + C` (Mac: `Cmd + C`)

**흔히 하는 실수**
- `node` 또는 `npm`을 찾을 수 없다는 에러 → 1주차에서 Node.js 설치 확인
- `EACCES` 권한 에러 → 관리자 권한 또는 다른 경로에서 시도

---

## 7. 실습: 카운터 앱 만들기 (30분)

### 요구사항
1. 증가/감소 버튼
2. 리셋 버튼
3. 현재 카운트 표시
4. 음수일 때 빨간색으로 표시

### 예시 코드
```jsx
import { useState } from 'react';

function Counter() {
    const [count, setCount] = useState(0);
    
    const increase = () => setCount(count + 1);
    const decrease = () => setCount(count - 1);
    const reset = () => setCount(0);
    
    return (
        <div>
            <h1>Counter: <span style={{ color: count < 0 ? 'red' : 'black' }}>
                {count}
            </span></h1>
            <button onClick={increase}>+</button>
            <button onClick={decrease}>-</button>
            <button onClick={reset}>Reset</button>
        </div>
    );
}

export default Counter;
```

---

## 📝 오늘의 핵심 정리
1. ✅ React는 컴포넌트 기반 UI 라이브러리
2. ✅ JSX는 JavaScript에 HTML 문법을 추가한 것
3. ✅ 컴포넌트는 재사용 가능한 UI 조각
4. ✅ Props는 부모에서 자식으로 데이터 전달
5. ✅ State는 컴포넌트 내부의 변경 가능한 데이터
6. ✅ 이벤트 핸들러로 사용자 상호작용 처리

## 🏠 과제
1. 개인 정보를 표시하는 Profile 컴포넌트 만들기
2. 간단한 계산기 컴포넌트 만들기 (덧셈, 뺄셈)
3. 다음 주차 준비: React Hooks 문서 읽어오기

## 📚 참고 자료
- [React 공식 문서](https://react.dev/)
- [React Beta 문서](https://beta.react.dev/)
- [JSX 소개](https://react.dev/learn/writing-markup-with-jsx)

