# 6주차 보조 자료

## Axios 고급 사용법

### 동시 요청
```javascript
// 여러 요청 동시 실행
const [users, posts] = await Promise.all([
    api.get('/users'),
    api.get('/posts')
]);

// 하나라도 실패하면 전체 실패
try {
    const results = await Promise.allSettled([
        api.get('/users'),
        api.get('/posts')
    ]);
} catch (error) {
    // 처리
}
```

### 요청 취소
```javascript
import axios from 'axios';

const CancelToken = axios.CancelToken;
const source = CancelToken.source();

api.get('/todos', {
    cancelToken: source.token
});

// 취소
source.cancel('Operation canceled');
```

## React Query 사용 (선택사항)

### 설치
```bash
npm install react-query
```

### 사용
```javascript
import { useQuery, useMutation } from 'react-query';
import api from './api/axios';

function TodoList() {
    const { data: todos, isLoading, error } = useQuery(
        'todos',
        () => api.get('/todos').then(res => res.data)
    );
    
    const createMutation = useMutation(
        (newTodo) => api.post('/todos', newTodo),
        {
            onSuccess: () => {
                queryClient.invalidateQueries('todos');
            }
        }
    );
    
    // 사용
    const handleCreate = () => {
        createMutation.mutate({ title: 'New Todo' });
    };
}
```

## 환경 변수 사용

### .env 파일
```env
REACT_APP_API_URL=http://localhost:8080/api
```

### 사용
```javascript
const api = axios.create({
    baseURL: process.env.REACT_APP_API_URL
});
```

## 타입스크립트와 함께 사용

### 타입 정의
```typescript
interface Todo {
    id: number;
    title: string;
    completed: boolean;
}

interface ApiResponse<T> {
    data: T;
    message: string;
}
```

### Axios 인스턴스 타입 지정
```typescript
const api = axios.create({
    baseURL: 'http://localhost:8080/api'
}) as AxiosInstance;

// 사용
const response = await api.get<Todo[]>('/todos');
const todos: Todo[] = response.data;
```

## 에러 처리 패턴

### 에러 타입 정의
```javascript
class ApiError extends Error {
    constructor(message, status, data) {
        super(message);
        this.status = status;
        this.data = data;
    }
}
```

### 통합 에러 처리
```javascript
// utils/errorHandler.js
export const handleApiError = (error) => {
    if (error.response) {
        const { status, data } = error.response;
        switch (status) {
            case 400:
                return '잘못된 요청입니다.';
            case 401:
                return '인증이 필요합니다.';
            case 403:
                return '권한이 없습니다.';
            case 404:
                return '요청한 리소스를 찾을 수 없습니다.';
            case 500:
                return '서버 오류가 발생했습니다.';
            default:
                return data.message || '알 수 없는 오류가 발생했습니다.';
        }
    } else if (error.request) {
        return '네트워크 오류가 발생했습니다.';
    } else {
        return '요청을 처리하는 중 오류가 발생했습니다.';
    }
};
```

## 로딩 스켈레톤

### 스켈레톤 컴포넌트
```javascript
function TodoSkeleton() {
    return (
        <div className="todo-skeleton">
            <div className="skeleton-line" />
            <div className="skeleton-line short" />
        </div>
    );
}

function TodoList() {
    const { todos, loading } = useTodos();
    
    if (loading) {
        return (
            <>
                <TodoSkeleton />
                <TodoSkeleton />
                <TodoSkeleton />
            </>
        );
    }
    
    return (
        // 실제 리스트
    );
}
```

## 최적화 팁

### 요청 중복 방지
```javascript
let fetching = false;

const fetchTodos = async () => {
    if (fetching) return;
    fetching = true;
    try {
        // 요청
    } finally {
        fetching = false;
    }
};
```

### 디바운싱
```javascript
import { debounce } from 'lodash';

const debouncedSearch = debounce(async (keyword) => {
    const response = await api.get(`/todos/search?q=${keyword}`);
    setResults(response.data);
}, 300);
```

