# 3주차 보조 자료

## useEffect 고급 사용법

### 여러 useEffect 사용
```jsx
function Component() {
    // 각각 독립적으로 관리
    useEffect(() => {
        // 구독 설정
    }, []);
    
    useEffect(() => {
        // 데이터 가져오기
    }, [userId]);
    
    useEffect(() => {
        // 타이머 설정
        return () => {
            // 클린업
        };
    }, []);
}
```

### 조건부 useEffect 실행
```jsx
function Component({ shouldFetch }) {
    useEffect(() => {
        if (shouldFetch) {
            // 조건부 실행
        }
    }, [shouldFetch]);
}
```

## useRef Hook

### DOM 참조
```jsx
import { useRef } from 'react';

function TextInput() {
    const inputRef = useRef(null);
    
    const focusInput = () => {
        inputRef.current.focus();
    };
    
    return (
        <div>
            <input ref={inputRef} type="text" />
            <button onClick={focusInput}>Focus Input</button>
        </div>
    );
}
```

### 값 저장 (렌더링 없이)
```jsx
function Timer() {
    const [count, setCount] = useState(0);
    const intervalRef = useRef(null);
    
    const startTimer = () => {
        intervalRef.current = setInterval(() => {
            setCount(prev => prev + 1);
        }, 1000);
    };
    
    const stopTimer = () => {
        clearInterval(intervalRef.current);
    };
    
    return (
        <div>
            <p>{count}</p>
            <button onClick={startTimer}>Start</button>
            <button onClick={stopTimer}>Stop</button>
        </div>
    );
}
```

## useMemo와 useCallback

### useMemo: 값 메모이제이션
```jsx
import { useMemo } from 'react';

function ExpensiveComponent({ items }) {
    const sortedItems = useMemo(() => {
        return items.sort((a, b) => a.price - b.price);
    }, [items]);
    
    return <div>{/* sortedItems 사용 */}</div>;
}
```

### useCallback: 함수 메모이제이션
```jsx
import { useCallback } from 'react';

function Parent({ items }) {
    const handleClick = useCallback((id) => {
        console.log('Clicked:', id);
    }, []);
    
    return <Child items={items} onClick={handleClick} />;
}
```

## React Router 고급

### Protected Route
```jsx
function ProtectedRoute({ children }) {
    const { isAuthenticated } = useAuth();
    
    if (!isAuthenticated) {
        return <Navigate to="/login" />;
    }
    
    return children;
}

// 사용
<Route 
    path="/dashboard" 
    element={
        <ProtectedRoute>
            <Dashboard />
        </ProtectedRoute>
    } 
/>
```

### Query Parameters
```jsx
import { useSearchParams } from 'react-router-dom';

function SearchPage() {
    const [searchParams, setSearchParams] = useSearchParams();
    const query = searchParams.get('q');
    
    const handleSearch = (newQuery) => {
        setSearchParams({ q: newQuery });
    };
    
    return <div>Search: {query}</div>;
}
```

## 폼 라이브러리

### React Hook Form (권장)
```bash
npm install react-hook-form
```

```jsx
import { useForm } from 'react-hook-form';

function MyForm() {
    const { register, handleSubmit, formState: { errors } } = useForm();
    
    const onSubmit = (data) => {
        console.log(data);
    };
    
    return (
        <form onSubmit={handleSubmit(onSubmit)}>
            <input {...register('email', { required: true })} />
            {errors.email && <span>Email is required</span>}
            <button type="submit">Submit</button>
        </form>
    );
}
```

## 에러 처리 패턴

### Error Boundary
```jsx
class ErrorBoundary extends React.Component {
    constructor(props) {
        super(props);
        this.state = { hasError: false };
    }
    
    static getDerivedStateFromError(error) {
        return { hasError: true };
    }
    
    componentDidCatch(error, errorInfo) {
        console.error('Error:', error, errorInfo);
    }
    
    render() {
        if (this.state.hasError) {
            return <h1>Something went wrong.</h1>;
        }
        
        return this.props.children;
    }
}

// 사용
<ErrorBoundary>
    <App />
</ErrorBoundary>
```

## 성능 최적화

### React.memo
```jsx
const ExpensiveComponent = React.memo(function ExpensiveComponent({ data }) {
    return <div>{/* 복잡한 렌더링 */}</div>;
});
```

### 코드 스플리팅
```jsx
import { lazy, Suspense } from 'react';

const LazyComponent = lazy(() => import('./LazyComponent'));

function App() {
    return (
        <Suspense fallback={<div>Loading...</div>}>
            <LazyComponent />
        </Suspense>
    );
}
```

