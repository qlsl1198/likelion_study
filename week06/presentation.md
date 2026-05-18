# 6주차: React와 Spring Boot API 연동 실습

이번 주 목표는 5주차에 만든 Todo API를 **React 화면에서 직접 호출**하는 것입니다.  
최종 결과물은 “목록 조회, 추가, 완료 토글, 삭제”가 되는 Todo 화면입니다.

---

## 오늘 만들 것

| 화면 기능 | 백엔드 API | 설명 |
|-----------|------------|------|
| 목록 불러오기 | `GET /api/todos` | 화면 첫 로딩 때 자동 호출 |
| 할 일 추가 | `POST /api/todos` | 입력값을 JSON으로 전송 |
| 완료 토글 | `PATCH /api/todos/{id}/toggle` | 완료 상태 변경 |
| 삭제 | `DELETE /api/todos/{id}` | 행 삭제 |
| 디버깅 | Chrome Network | 요청/응답 확인 |

---

## 오늘 알아야 할 단어

| 단어 | 의미 |
|------|------|
| CORS | 브라우저가 다른 출처 요청을 막을 때 서버에서 허용해주는 설정 |
| Axios | React에서 API 요청을 쉽게 보내는 라이브러리 |
| State | 화면에 표시할 데이터와 상태 |
| Network 탭 | 실제 요청이 갔는지 확인하는 개발자도구 |

---

## 진행 순서

1. 백엔드 API 단독 확인
2. Spring Boot CORS 설정
3. React 프로젝트 생성과 Axios 설치
4. `api/axios.js` 작성
5. `App.js` 한 파일로 CRUD 구현
6. Network 탭으로 요청 검증
7. `useTodos` 훅으로 분리
8. 인터셉터, 로딩/에러 처리 정리

---

## Lab 0. 백엔드 먼저 확인

5주차 Spring Boot 프로젝트를 실행합니다.

```bash
./mvnw spring-boot:run
```

Postman으로 확인합니다.

```http
GET http://localhost:8080/api/todos
```

프론트엔드를 만들기 전에 백엔드 단독 호출이 먼저 성공해야 합니다.

---

## Lab 1. CORS 설정

`src/main/java/com/likelion/todoapi/config/CorsConfig.java`

```java
package com.likelion.todoapi.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**")
                        .allowedOrigins("http://localhost:3000")
                        .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
                        .allowedHeaders("*");
            }
        };
    }
}
```

React 포트가 5173이면 `http://localhost:5173`도 허용해야 합니다.  
설정 후 백엔드는 반드시 재실행합니다.

---

## Lab 2. React 프로젝트와 Axios

```bash
npx create-react-app todo-front
cd todo-front
npm install axios
npm start
```

브라우저에서 `http://localhost:3000`이 열리면 성공입니다.

---

## Lab 3. Axios 인스턴스

`src/api/axios.js`

```javascript
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8080/api',
  headers: { 'Content-Type': 'application/json' },
  timeout: 10000,
});

export default api;
```

`api.get('/todos')`는 실제로 `GET http://localhost:8080/api/todos`로 요청됩니다.

---

## Lab 4. App.js 전체 구현

처음에는 훅 분리 없이 한 파일에서 동작을 완성합니다.

```javascript
import { useEffect, useState } from 'react';
import api from './api/axios';

function App() {
  const [items, setItems] = useState([]);
  const [title, setTitle] = useState('');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');
  const [workingId, setWorkingId] = useState(null);

  const load = async () => {
    setLoading(true);
    setMessage('');

    try {
      const res = await api.get('/todos');
      setItems(Array.isArray(res.data) ? res.data : []);
    } catch (e) {
      console.error(e);
      setMessage('목록 불러오기 실패 - 백엔드 실행과 CORS를 확인하세요.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    load();
  }, []);

  const handleAdd = async (e) => {
    e.preventDefault();

    if (!title.trim()) {
      setMessage('할 일을 입력하세요.');
      return;
    }

    try {
      await api.post('/todos', { title, description: '' });
      setTitle('');
      await load();
    } catch (e) {
      console.error(e);
      setMessage('추가 실패 - 서버 로그와 Network 탭을 확인하세요.');
    }
  };

  const handleToggle = async (id) => {
    setWorkingId(id);
    try {
      await api.patch(`/todos/${id}/toggle`);
      await load();
    } catch (e) {
      console.error(e);
      setMessage('완료 상태 변경 실패');
    } finally {
      setWorkingId(null);
    }
  };

  const handleDelete = async (id) => {
    setWorkingId(id);
    try {
      await api.delete(`/todos/${id}`);
      await load();
    } catch (e) {
      console.error(e);
      setMessage('삭제 실패');
    } finally {
      setWorkingId(null);
    }
  };

  return (
    <div style={{ maxWidth: 560, margin: '40px auto', fontFamily: 'sans-serif' }}>
      <h1>Todo 연동 실습</h1>

      <form onSubmit={handleAdd} style={{ marginBottom: 16 }}>
        <input
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          placeholder="할 일 입력"
          style={{ width: '70%', padding: 8 }}
        />
        <button type="submit" style={{ padding: '8px 12px', marginLeft: 8 }}>
          추가
        </button>
      </form>

      {loading && <p>불러오는 중...</p>}
      {message && <p style={{ color: 'crimson' }}>{message}</p>}

      <ul style={{ paddingLeft: 18 }}>
        {items.map((todo) => (
          <li key={todo.id} style={{ marginBottom: 8 }}>
            <button
              type="button"
              disabled={workingId === todo.id}
              onClick={() => handleToggle(todo.id)}
            >
              {todo.completed ? '완료' : '미완료'}
            </button>
            <span style={{ marginLeft: 8, textDecoration: todo.completed ? 'line-through' : 'none' }}>
              {todo.title}
            </span>
            <button type="button" onClick={() => handleDelete(todo.id)} style={{ marginLeft: 8 }}>
              삭제
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;
```

---

## Lab 5. 동작 확인

1. 백엔드 실행: `localhost:8080`
2. 프론트 실행: `localhost:3000`
3. 브라우저 새로고침 → 목록 조회
4. 입력 후 추가 → 목록 증가
5. 완료 버튼 → 완료/미완료 변경
6. 삭제 버튼 → 목록에서 제거

---

## Lab 6. Network 탭 디버깅

1. F12 또는 우클릭 → 검사
2. Network 탭 열기
3. 페이지 새로고침
4. `todos` 요청 클릭
5. Status Code, Request URL, Response 확인

문제가 생기면 “화면이 안 됨”보다 먼저 “요청이 갔는지”를 확인합니다.

---

## Lab 7. `useTodos` 훅으로 분리

`src/hooks/useTodos.js`

```javascript
import { useCallback, useEffect, useState } from 'react';
import api from '../api/axios';

export default function useTodos() {
  const [todos, setTodos] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchTodos = useCallback(async () => {
    setLoading(true);
    setError(null);

    try {
      const res = await api.get('/todos');
      setTodos(Array.isArray(res.data) ? res.data : []);
    } catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchTodos();
  }, [fetchTodos]);

  const createTodo = async (payload) => {
    const res = await api.post('/todos', payload);
    await fetchTodos();
    return res.data;
  };

  const toggleTodo = async (id) => {
    const res = await api.patch(`/todos/${id}/toggle`);
    await fetchTodos();
    return res.data;
  };

  const deleteTodo = async (id) => {
    await api.delete(`/todos/${id}`);
    await fetchTodos();
  };

  return {
    todos,
    loading,
    error,
    fetchTodos,
    createTodo,
    toggleTodo,
    deleteTodo,
  };
}
```

---

## Lab 8. Axios 인터셉터

`src/api/axios.js` 아래에 추가합니다.

```javascript
api.interceptors.response.use(
  (res) => res,
  (err) => {
    if (!err.response) {
      console.error('서버 연결 실패 또는 네트워크 오류');
    } else {
      console.error('HTTP', err.response.status, err.response.data);
    }

    return Promise.reject(err);
  }
);
```

---

## 자주 나는 문제

| 증상 | 확인 |
|------|------|
| CORS 에러 | `CorsConfig`, `allowedOrigins`, 백엔드 재실행 |
| Network Error | 백엔드 실행 여부, 포트, `baseURL` |
| 404 | `/api` 경로 누락 여부 |
| 화면에는 안 나오는데 Network 200 | React state 업데이트 확인 |
| 추가가 안 됨 | POST body에 `title`이 있는지 확인 |

---

## 과제 안내

- 백엔드와 프론트를 동시에 실행한다.
- 목록 조회, 추가, 삭제, 완료 토글 중 최소 3개 이상 구현한다.
- Network 탭 또는 화면 동작 캡처를 제출한다.
- README에 실행 순서를 적는다.
- `node_modules/`는 GitHub에 올리지 않는다.
