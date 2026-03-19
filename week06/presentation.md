# 6주차: 프론트엔드-백엔드 연동

## 💡 비전공자를 위한 한눈에 보기

- **CORS**: 브라우저 보안 때문에, 다른 도메인(예: localhost:3000 → localhost:8080)으로 요청이 막힐 수 있음. 서버에서 "이 출처는 허용해줘"라고 설정하는 것
- **Axios**: HTTP 요청을 편하게 보내는 라이브러리. `fetch`보다 설정이 간단하고, 요청/응답 가로채기(인터셉터) 기능이 있음

---

## 📋 학습 목표
- CORS를 이해하고 설정할 수 있다
- Axios를 사용하여 API를 호출할 수 있다
- 에러 처리 및 로딩 상태를 관리할 수 있다
- React와 Spring Boot를 통합할 수 있다
- 실제 프로젝트를 완성할 수 있다

---

## 1. CORS 설정 (30분)

### 1.1 CORS란?
- **정의**: Cross-Origin Resource Sharing - 다른 출처(도메인)의 리소스에 접근할 수 있도록 허용하는 메커니즘
- **왜 필요한가?**: React 앱(`http://localhost:3000`)과 Spring Boot API(`http://localhost:8080`)는 서로 다른 출처이므로, 브라우저 기본 보안 정책상 API 요청이 차단됨
- **동일 출처 정책 (Same-Origin Policy)**:
  - 프로토콜, 도메인, 포트가 모두 같아야 "동일 출처"
  - 예: `http://localhost:3000`과 `http://localhost:8080`은 포트가 달라서 다른 출처
  - XSS, CSRF 같은 공격을 막기 위한 브라우저의 기본 보안 장치
- **해결 방법**: 백엔드 서버에서 CORS 헤더를 응답에 포함해, 특정 출처의 요청을 허용한다고 명시

### 1.2 CORS 설정 방법

#### Spring Boot에서 설정
```java
@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**")
                    .allowedOrigins("http://localhost:3000")
                    .allowedMethods("GET", "POST", "PUT", "DELETE", "PATCH")
                    .allowedHeaders("*")
                    .allowCredentials(true);
            }
        };
    }
}
```

#### application.properties에서 설정
```properties
# CORS 설정 (간단한 경우)
spring.web.cors.allowed-origins=http://localhost:3000
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE
```

#### CORS 설정 따라하기 (백엔드)

1. Spring Boot 프로젝트에 `config` 패키지 생성 (없다면)
2. `CorsConfig.java` 새 클래스 생성
3. 위 코드 복사 후 저장
4. **주의**: `allowedOrigins("http://localhost:3000")` 에 프론트엔드 주소 맞게 수정

#### 프론트엔드·백엔드 동시 실행 - 따라하기

- **터미널 1**: 백엔드 실행  
  - **Mac/Linux**: `cd backend` → `./mvnw spring-boot:run`
  - **Windows**: `cd backend` → `mvnw.cmd spring-boot:run`
- **터미널 2**: 프론트엔드 실행  
  `cd frontend` → `npm start`
- 둘 다 띄운 뒤 브라우저에서 `http://localhost:3000` 접속

---

## 2. Axios 설치 및 설정 (30분)

### 2.1 Axios란?
- **정의**: HTTP 클라이언트 라이브러리 - 서버와 통신할 때 사용하는 JavaScript 라이브러리
- **fetch() vs Axios**:
  - `fetch`: 브라우저 내장 API, 설정이 번거롭고 에러 처리가 불편함 (404도 `catch`로 가지 않음)
  - Axios: 자동 JSON 변환, 인터셉터로 요청/응답 공통 처리, 타임아웃 설정 등 개발 편의 기능 제공
  - 실무에서는 Axios를 더 많이 사용
- **특징**: Promise 기반, 브라우저/Node.js 지원, 요청 취소, 진행률 업로드 등

### 2.2 설치 - 따라하기

- **1단계**: React 프로젝트 폴더에서 터미널 열기
- **2단계**: `npm install axios` 실행
- **3단계**: 설치 확인: `package.json`의 `dependencies`에 `"axios"` 항목이 보이면 성공

```bash
npm install axios
```

### 2.3 기본 사용법
```javascript
import axios from 'axios';

// GET 요청
axios.get('/api/todos')
    .then(response => {
        console.log(response.data);
    })
    .catch(error => {
        console.error(error);
    });

// POST 요청
axios.post('/api/todos', {
    title: 'New Todo',
    completed: false
})
    .then(response => {
        console.log(response.data);
    })
    .catch(error => {
        console.error(error);
    });
```

### 2.4 Axios 인스턴스 생성
```javascript
// api/axios.js
import axios from 'axios';

const api = axios.create({
    baseURL: 'http://localhost:8080/api',
    timeout: 10000,
    headers: {
        'Content-Type': 'application/json'
    }
});

export default api;
```

---

## 3. API 호출 구현 (90분)

### 3.1 커스텀 Hook 만들기
```javascript
// hooks/useTodos.js
import { useState, useEffect } from 'react';
import api from '../api/axios';

function useTodos() {
    const [todos, setTodos] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    
    useEffect(() => {
        fetchTodos();
    }, []);
    
    const fetchTodos = async () => {
        try {
            setLoading(true);
            const response = await api.get('/todos');
            setTodos(response.data);
            setError(null);
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };
    
    const createTodo = async (todoData) => {
        try {
            const response = await api.post('/todos', todoData);
            setTodos(prev => [...prev, response.data]);
            return response.data;
        } catch (err) {
            throw err;
        }
    };
    
    const updateTodo = async (id, todoData) => {
        try {
            const response = await api.put(`/todos/${id}`, todoData);
            setTodos(prev => prev.map(todo => 
                todo.id === id ? response.data : todo
            ));
            return response.data;
        } catch (err) {
            throw err;
        }
    };
    
    const deleteTodo = async (id) => {
        try {
            await api.delete(`/todos/${id}`);
            setTodos(prev => prev.filter(todo => todo.id !== id));
        } catch (err) {
            throw err;
        }
    };
    
    return {
        todos,
        loading,
        error,
        fetchTodos,
        createTodo,
        updateTodo,
        deleteTodo
    };
}

export default useTodos;
```

### 3.2 컴포넌트에서 사용
```javascript
// components/TodoList.js
import { useState } from 'react';
import useTodos from '../hooks/useTodos';

function TodoList() {
    const { todos, loading, error, createTodo, deleteTodo } = useTodos();
    const [title, setTitle] = useState('');
    
    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            await createTodo({ title, completed: false });
            setTitle('');
        } catch (err) {
            alert('Failed to create todo');
        }
    };
    
    if (loading) return <div>Loading...</div>;
    if (error) return <div>Error: {error}</div>;
    
    return (
        <div>
            <form onSubmit={handleSubmit}>
                <input
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                    placeholder="New todo"
                />
                <button type="submit">Add</button>
            </form>
            
            <ul>
                {todos.map(todo => (
                    <li key={todo.id}>
                        {todo.title}
                        <button onClick={() => deleteTodo(todo.id)}>
                            Delete
                        </button>
                    </li>
                ))}
            </ul>
        </div>
    );
}
```

---

## 4. 에러 처리 (60분)

### 4.1 Axios 인터셉터
```javascript
// api/axios.js
import axios from 'axios';

const api = axios.create({
    baseURL: 'http://localhost:8080/api'
});

// 요청 인터셉터
api.interceptors.request.use(
    config => {
        // 토큰 추가 등
        const token = localStorage.getItem('token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    error => {
        return Promise.reject(error);
    }
);

// 응답 인터셉터
api.interceptors.response.use(
    response => response,
    error => {
        if (error.response) {
            // 서버 응답 에러
            switch (error.response.status) {
                case 401:
                    // 인증 에러 처리
                    break;
                case 404:
                    // Not Found 처리
                    break;
                case 500:
                    // 서버 에러 처리
                    break;
            }
        }
        return Promise.reject(error);
    }
);

export default api;
```

### 4.2 에러 상태 관리
```javascript
function useTodos() {
    const [error, setError] = useState(null);
    
    const handleError = (err) => {
        if (err.response) {
            // 서버 응답 에러
            setError(err.response.data.message || 'An error occurred');
        } else if (err.request) {
            // 요청은 보냈지만 응답을 받지 못함
            setError('Network error. Please check your connection.');
        } else {
            // 요청 설정 중 에러
            setError('An unexpected error occurred');
        }
    };
    
    // 사용
    const fetchTodos = async () => {
        try {
            // ...
        } catch (err) {
            handleError(err);
        }
    };
}
```

---

## 5. 로딩 상태 관리 (30분)

### 5.1 로딩 상태 표시
```javascript
function TodoList() {
    const { todos, loading, error } = useTodos();
    
    if (loading) {
        return (
            <div className="loading">
                <Spinner />
                <p>Loading todos...</p>
            </div>
        );
    }
    
    if (error) {
        return (
            <div className="error">
                <p>{error}</p>
                <button onClick={fetchTodos}>Retry</button>
            </div>
        );
    }
    
    return (
        <div>
            {/* Todo 리스트 */}
        </div>
    );
}
```

### 5.2 개별 작업 로딩 상태
```javascript
function TodoItem({ todo }) {
    const [updating, setUpdating] = useState(false);
    
    const handleToggle = async () => {
        setUpdating(true);
        try {
            await updateTodo(todo.id, { completed: !todo.completed });
        } finally {
            setUpdating(false);
        }
    };
    
    return (
        <li>
            {updating ? (
                <span>Updating...</span>
            ) : (
                <>
                    <input
                        type="checkbox"
                        checked={todo.completed}
                        onChange={handleToggle}
                    />
                    {todo.title}
                </>
            )}
        </li>
    );
}
```

---

## 6. 실습: React + Spring Boot 통합 (60분)

### 요구사항
1. Spring Boot API 서버 실행
2. React 앱에서 API 호출
3. CRUD 기능 완전 구현
4. 에러 처리 및 로딩 상태

### 프로젝트 구조
```
project/
├── backend/          # Spring Boot
│   └── src/
└── frontend/         # React
    └── src/
        ├── api/
        ├── hooks/
        └── components/
```

---

## 📝 오늘의 핵심 정리
1. ✅ CORS 설정 방법
2. ✅ Axios를 사용한 API 호출
3. ✅ 커스텀 Hook으로 API 로직 분리
4. ✅ 에러 처리 및 로딩 상태 관리
5. ✅ React와 Spring Boot 통합

## 🏠 과제
1. Todo 앱을 React와 Spring Boot로 완성하기
2. 에러 처리 및 로딩 상태 추가하기
3. 다음 주차 준비: JWT 인증 문서 읽어오기

## 📚 참고 자료
- [Axios 공식 문서](https://axios-http.com/)
- [CORS 설명](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [React와 API 통신](https://react.dev/learn/synchronizing-with-effects)

