# 3주차: React 심화

## 📋 학습 목표
- React Hooks를 이해하고 사용할 수 있다
- useEffect를 활용하여 사이드 이펙트를 처리할 수 있다
- React Router를 사용하여 라우팅을 구현할 수 있다
- 폼 처리 및 검증을 할 수 있다
- Context API를 이해한다

---

## 🔧 3주차 준비: React Router 설치 따라하기

**이번 주 실습 전에** 다음을 따라 해두세요.

### React Router 설치
```bash
# 기존 React 프로젝트 폴더로 이동 (예: my-first-app)
cd my-first-app

# React Router DOM 설치
npm install react-router-dom
```

- **💡 비전공자용 설명**: React Router = 페이지 이동(라우팅)을 담당하는 라이브러리. 링크 클릭 시 전체 페이지를 새로고침하지 않고 필요한 부분만 바꿔 줍니다.
- **설치 확인**: `package.json`의 `dependencies`에 `"react-router-dom"` 항목이 추가되면 성공

### npm install이란?
- `npm install [패키지명]`: 해당 패키지를 프로젝트에 추가하고, `node_modules` 폴더에 설치
- 프로젝트 폴더에서 실행해야 함 (`cd`로 이동 후)

---

## 1. React Hooks 소개 (30분)

### 1.1 Hooks란?
- **정의**: 함수형 컴포넌트에서 State와 생명주기 기능을 사용할 수 있게 해주는 함수
- **왜 Hooks인가?**: 예전 React는 클래스 컴포넌트만 State를 가질 수 있었음. Hooks 도입으로 함수형 컴포넌트에서도 상태 관리·생명주기·부가 로직을 사용할 수 있게 되어, 코드가 더 간결하고 재사용이 쉬워짐
- **규칙**:
  - 최상위 레벨에서만 호출 (조건·반복 밖에서)
  - 조건문, 반복문, 중첩 함수에서 호출 금지
  - React 함수 컴포넌트 또는 커스텀 Hook에서만 호출
- **규칙을 지켜야 하는 이유**: React는 컴포넌트 내부에서 Hook 호출 순서로 상태를 추적함. 순서가 바뀌면 상태가 잘못 연결될 수 있음

### 1.2 주요 Hooks
- `useState`: State 관리
- `useEffect`: 사이드 이펙트 처리
- `useContext`: Context 사용
- `useRef`: DOM 참조 또는 값 저장
- `useMemo`: 값 메모이제이션
- `useCallback`: 함수 메모이제이션

---

## 2. useEffect (90분)

### 2.1 useEffect란?
- **정의**: 컴포넌트가 렌더링된 후 실행되는 Hook
- **"사이드 이펙트"란?**: 렌더링 결과와 직접적인 관련이 없는 부가 작업. 예: API 호출, 타이머, 구독, DOM 조작 등
- **왜 useEffect인가?**: 렌더링은 순수해야 함(같은 props/state → 같은 결과). API 호출 같은 부수 효과는 렌더링 이후 useEffect에서 분리해 처리
- **용도**: 
  - 데이터 가져오기 (fetch, API 호출)
  - 구독 설정 (WebSocket, 이벤트 리스너)
  - DOM 수동 조작
  - 타이머 설정 (setInterval, setTimeout)

### 2.2 기본 사용법
```jsx
import { useEffect } from 'react';

function Component() {
    useEffect(() => {
        // 컴포넌트가 마운트될 때 실행
        console.log('Component mounted');
        
        // 클린업 함수 (선택사항)
        return () => {
            console.log('Component unmounted');
        };
    });
    
    return <div>Content</div>;
}
```

### 2.3 의존성 배열
```jsx
// 1. 의존성 배열 없음 - 매 렌더링마다 실행
useEffect(() => {
    console.log('Every render');
});

// 2. 빈 배열 - 마운트 시 한 번만 실행
useEffect(() => {
    console.log('Only on mount');
}, []);

// 3. 의존성 배열 있음 - 특정 값 변경 시 실행
useEffect(() => {
    console.log('When count changes');
}, [count]);
```

### 2.4 데이터 가져오기
```jsx
function UserProfile({ userId }) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    
    useEffect(() => {
        async function fetchUser() {
            setLoading(true);
            try {
                const response = await fetch(`/api/users/${userId}`);
                const data = await response.json();
                setUser(data);
            } catch (error) {
                console.error('Error:', error);
            } finally {
                setLoading(false);
            }
        }
        
        fetchUser();
    }, [userId]);  // userId가 변경될 때마다 실행
    
    if (loading) return <div>Loading...</div>;
    if (!user) return <div>User not found</div>;
    
    return <div>{user.name}</div>;
}
```

### 2.5 클린업 함수
```jsx
function Timer() {
    const [seconds, setSeconds] = useState(0);
    
    useEffect(() => {
        const interval = setInterval(() => {
            setSeconds(prev => prev + 1);
        }, 1000);
        
        // 클린업: 컴포넌트 언마운트 시 타이머 정리
        return () => clearInterval(interval);
    }, []);
    
    return <div>Seconds: {seconds}</div>;
}
```

---

## 3. useContext (60분)

### 3.1 Context API란?
- **정의**: Props drilling을 피하기 위한 전역 상태 관리 방법
- **Props drilling이란?**: 깊은 컴포넌트 트리에서 상위 → 하위로 계속 props를 넘기는 것. 중간 컴포넌트들은 그 값이 필요 없어도 전달만 해야 하는 반복 발생
- **Context로 해결**: Provider가 값을 한 번에 내려주고, 필요한 컴포넌트는 useContext로 직접 꺼내 씀. 중간 레벨에 props를 넘길 필요 없음
- **용도**: 여러 컴포넌트에서 공유해야 하는 데이터 (테마, 사용자 정보, 로케일 등)

### 3.2 Context 생성 및 사용
```jsx
// 1. Context 생성
import { createContext } from 'react';

const ThemeContext = createContext('light');

// 2. Provider로 감싸기
function App() {
    const [theme, setTheme] = useState('light');
    
    return (
        <ThemeContext.Provider value={{ theme, setTheme }}>
            <Header />
            <Content />
        </ThemeContext.Provider>
    );
}

// 3. useContext로 사용
import { useContext } from 'react';

function Header() {
    const { theme, setTheme } = useContext(ThemeContext);
    
    return (
        <header className={theme}>
            <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}>
                Toggle Theme
            </button>
        </header>
    );
}
```

### 3.3 커스텀 Hook으로 Context 사용
```jsx
// useTheme.js
function useTheme() {
    const context = useContext(ThemeContext);
    if (!context) {
        throw new Error('useTheme must be used within ThemeProvider');
    }
    return context;
}

// 사용
function Component() {
    const { theme, setTheme } = useTheme();
    // ...
}
```

---

## 4. React Router (90분)

### 4.1 React Router란?
- **정의**: React 애플리케이션에서 라우팅을 처리하는 라이브러리
- **왜 필요한가?**: React는 SPA(Single Page Application)로 한 HTML만 사용. URL 변경 시 어떤 컴포넌트를 보여줄지 결정하는 라우팅이 필요함
- **주요 구성요소**: BrowserRouter(history 기반), Routes/Route(경로 매핑), Link(페이지 이동), useNavigate(프로그래밍 방식 이동)
- **설치**: `npm install react-router-dom`

### 4.2 기본 설정
```jsx
import { BrowserRouter, Routes, Route } from 'react-router-dom';

function App() {
    return (
        <BrowserRouter>
            <Routes>
                <Route path="/" element={<Home />} />
                <Route path="/about" element={<About />} />
                <Route path="/contact" element={<Contact />} />
            </Routes>
        </BrowserRouter>
    );
}
```

### 4.3 Link와 NavLink
```jsx
import { Link, NavLink } from 'react-router-dom';

function Navigation() {
    return (
        <nav>
            <Link to="/">Home</Link>
            <Link to="/about">About</Link>
            
            {/* NavLink: 활성 상태 스타일링 가능 */}
            <NavLink 
                to="/contact" 
                className={({ isActive }) => isActive ? 'active' : ''}
            >
                Contact
            </NavLink>
        </nav>
    );
}
```

### 4.4 useNavigate Hook
```jsx
import { useNavigate } from 'react-router-dom';

function LoginForm() {
    const navigate = useNavigate();
    
    const handleSubmit = async (e) => {
        e.preventDefault();
        // 로그인 로직...
        navigate('/dashboard');  // 프로그래밍 방식으로 이동
    };
    
    return <form onSubmit={handleSubmit}>...</form>;
}
```

### 4.5 URL 파라미터
```jsx
// 라우트 설정
<Route path="/user/:id" element={<UserProfile />} />

// 컴포넌트에서 사용
import { useParams } from 'react-router-dom';

function UserProfile() {
    const { id } = useParams();
    // id 사용...
}
```

### 4.6 중첩 라우팅
```jsx
<Route path="/dashboard" element={<Dashboard />}>
    <Route path="profile" element={<Profile />} />
    <Route path="settings" element={<Settings />} />
</Route>

// Dashboard 컴포넌트
function Dashboard() {
    return (
        <div>
            <Sidebar />
            <Outlet />  {/* 중첩 라우트 렌더링 */}
        </div>
    );
}
```

---

## 5. 폼 처리 및 검증 (90분)

### 5.1 제어 컴포넌트 (Controlled Component)
- **정의**: input의 value가 React state에 의해 완전히 제어되는 폼 요소
- **비제어 vs 제어**: 비제어는 DOM이 값을 직접 관리하고, 제어는 React state가 값의 유일한 원천. 제어 컴포넌트는 실시간 검증·조건부 비활성화 등에 유리함

### 5.1-2 제어 컴포넌트 구현
```jsx
function LoginForm() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    
    const handleSubmit = (e) => {
        e.preventDefault();
        console.log({ email, password });
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

### 5.2 폼 검증
```jsx
function SignupForm() {
    const [formData, setFormData] = useState({
        email: '',
        password: '',
        confirmPassword: ''
    });
    const [errors, setErrors] = useState({});
    
    const validate = () => {
        const newErrors = {};
        
        if (!formData.email) {
            newErrors.email = 'Email is required';
        } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
            newErrors.email = 'Email is invalid';
        }
        
        if (!formData.password) {
            newErrors.password = 'Password is required';
        } else if (formData.password.length < 8) {
            newErrors.password = 'Password must be at least 8 characters';
        }
        
        if (formData.password !== formData.confirmPassword) {
            newErrors.confirmPassword = 'Passwords do not match';
        }
        
        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };
    
    const handleSubmit = (e) => {
        e.preventDefault();
        if (validate()) {
            console.log('Form is valid!');
        }
    };
    
    const handleChange = (e) => {
        setFormData({
            ...formData,
            [e.target.name]: e.target.value
        });
    };
    
    return (
        <form onSubmit={handleSubmit}>
            <div>
                <input
                    type="email"
                    name="email"
                    value={formData.email}
                    onChange={handleChange}
                />
                {errors.email && <span className="error">{errors.email}</span>}
            </div>
            <div>
                <input
                    type="password"
                    name="password"
                    value={formData.password}
                    onChange={handleChange}
                />
                {errors.password && <span className="error">{errors.password}</span>}
            </div>
            <div>
                <input
                    type="password"
                    name="confirmPassword"
                    value={formData.confirmPassword}
                    onChange={handleChange}
                />
                {errors.confirmPassword && <span className="error">{errors.confirmPassword}</span>}
            </div>
            <button type="submit">Sign Up</button>
        </form>
    );
}
```

### 5.3 커스텀 Hook으로 폼 관리
```jsx
function useForm(initialValues, validate) {
    const [values, setValues] = useState(initialValues);
    const [errors, setErrors] = useState({});
    
    const handleChange = (e) => {
        const { name, value } = e.target;
        setValues({ ...values, [name]: value });
        
        // 실시간 검증
        if (validate) {
            const fieldErrors = validate({ [name]: value });
            setErrors({ ...errors, ...fieldErrors });
        }
    };
    
    const handleSubmit = (onSubmit) => (e) => {
        e.preventDefault();
        if (validate) {
            const formErrors = validate(values);
            setErrors(formErrors);
            if (Object.keys(formErrors).length === 0) {
                onSubmit(values);
            }
        } else {
            onSubmit(values);
        }
    };
    
    return { values, errors, handleChange, handleSubmit };
}

// 사용
function MyForm() {
    const { values, errors, handleChange, handleSubmit } = useForm(
        { email: '', password: '' },
        validateForm
    );
    
    return (
        <form onSubmit={handleSubmit((data) => console.log(data))}>
            {/* ... */}
        </form>
    );
}
```

---

## 6. 실습: Todo 리스트 앱 완성 (30분)

### 요구사항
1. React Router로 페이지 분리
   - `/`: Todo 리스트
   - `/about`: About 페이지
2. Context API로 전역 상태 관리
3. useEffect로 로컬 스토리지 저장
4. 폼 검증 추가

### 예시 구조
```jsx
// TodoContext.js
const TodoContext = createContext();

// App.js
function App() {
    return (
        <BrowserRouter>
            <TodoProvider>
                <Routes>
                    <Route path="/" element={<TodoList />} />
                    <Route path="/about" element={<About />} />
                </Routes>
            </TodoProvider>
        </BrowserRouter>
    );
}
```

---

## 📝 오늘의 핵심 정리
1. ✅ useEffect로 사이드 이펙트 처리
2. ✅ useContext로 전역 상태 관리
3. ✅ React Router로 라우팅 구현
4. ✅ 폼 처리 및 검증 구현
5. ✅ 커스텀 Hook 활용

## 🏠 과제
1. useEffect를 사용한 데이터 fetching 연습
2. React Router로 멀티 페이지 앱 만들기
3. 폼 검증이 포함된 회원가입 폼 만들기
4. 다음 주차 준비: Spring Boot 공식 문서 읽어오기

## 📚 참고 자료
- [React Hooks 공식 문서](https://react.dev/reference/react)
- [React Router 공식 문서](https://reactrouter.com/)
- [useEffect 완벽 가이드](https://overreacted.io/a-complete-guide-to-useeffect/)

