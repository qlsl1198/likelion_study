# 6주차: React에서 Spring API 부르기 (실습 위주 · 비전공 입문용)

이론은 **한 페이지**만 보고, 나머지는 **복붙 + 순서대로 실행**입니다.

---

## 한 페이지 이론 (1분)

| 말 | 뜻 |
|----|---|
| **CORS** | 브라우저가 `localhost:3000`(React) → `localhost:8080`(Spring) 요청을 **막을 수 있다**. 서버가 “3000 허용”이라고 해야 통과한다. |
| **Axios** | `fetch` 대신 편하게 `get/post` 하는 라이브러리. 우리는 `baseURL` 한 번만 정한다. |

끝. 아래부터는 **실습만**.

---

## 오늘이 끝나면 할 수 있는 것

- 백엔드·프론트 **둘 다 켠 상태**에서  
- 화면에 **목록 표시**, 입력하고 **추가** 버튼 누르면 DB에 들어 간 것처럼 **화면 갱신**  
- (선택) **삭제** 버튼

---

## 수업 순서

1. 【Lab 0】 Spring — CORS 허용 (파일 하나)  
2. 【Lab 1】 React 앱 만들기 + `axios` 설치  
3. 【Lab 2】 `api/axios.js` — 주소 고정  
4. 【Lab 3】 **한 파일(`App.js`)** 로 목록 GET + 새 글 POST (비전공 메인 코스)  
5. 【Lab 4·선택】 같은 내용을 `hooks/useTodos.js` 로 옮겨 깔끔하게 정리  
6. 【Lab 5·선택】 삭제 버튼, 간단 에러 메시지  

백엔드는 **5주차 또는 4주차의 `/api/todos`** 가 살아 있어야 합니다. 없으면 5주 `presentation.md` Lab만 먼저 끝낸 프로젝트를 띄우세요.

---

## 【Lab 0】 Spring CORS (5분)

`.../config/CorsConfig.java` **새로 만들고** 안에 그대로:

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

**주의**: React를 **다른 포트**로 띄우면 `allowedOrigins` 에 그 포트를 넣는다.

백엔드 재실행 → 끝.

---

## 【Lab 1】 React + axios (10분)

터미널:

```bash
npx create-react-app todo-front
cd todo-front
npm install axios
npm start
```

브라우저에 `localhost:3000` 뜨면 다음.

---

## 【Lab 2】 `src/api/axios.js` (3분)

```javascript
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8080/api',
  headers: { 'Content-Type': 'application/json' },
  timeout: 10000,
});

export default api;
```

**백엔드 포트가 8081이면** `baseURL` 도 `http://localhost:8081/api` 로 수정.

---

## 【Lab 3】 `src/App.js` 전부 교체 (비전공 핵심, 25분)

아래는 **복붙용 전체 예시**. `index.css` 등은 초기 상태 그대로 두어도 됨.

```javascript
import { useEffect, useState } from 'react';
import api from './api/axios';

function App() {
  const [items, setItems] = useState([]);
  const [title, setTitle] = useState('');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');

  const load = async () => {
    setLoading(true);
    setMessage('');
    try {
      const res = await api.get('/todos');
      setItems(Array.isArray(res.data) ? res.data : []);
    } catch (e) {
      console.error(e);
      setMessage('목록 불러오기 실패 — 백엔드 실행·CORS 확인');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleAdd = async (e) => {
    e.preventDefault();
    if (!title.trim()) return;
    setMessage('');
    try {
      await api.post('/todos', { title, description: '' });
      setTitle('');
      await load();
    } catch (e) {
      console.error(e);
      setMessage('추가 실패 — 네트워크 탭·서버 로그 확인');
    }
  };

  const handleDelete = async (id) => {
    try {
      await api.delete(`/todos/${id}`);
      await load();
    } catch (e) {
      console.error(e);
      setMessage('삭제 실패');
    }
  };

  return (
    <div style={{ maxWidth: 520, margin: '40px auto', fontFamily: 'sans-serif' }}>
      <h1>Todo (연동)</h1>

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
        {items.map((t) => (
          <li key={t.id} style={{ marginBottom: 8 }}>
            {t.completed ? '[v] ' : '[ ] '} {t.title}
            <button type="button" onClick={() => handleDelete(t.id)} style={{ marginLeft: 8 }}>
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

**확인 순서**

1. 터미널 A: `./mvnw spring-boot:run` (백엔드)  
2. 터미널 B: `npm start` (프론트)  
3. 새로고침 → 목록 표시  
4. 입력 후 추가 → 목록 증가  
5. 크롬 F12 → **Network** 에서 요청 상태 200 확인  

**자주 나는 문제**

| 증상 | 볼 곳 |
|------|------|
| 콘솔에 CORS 에러 | Lab 0 `allowedOrigins` 가 `http://localhost:3000` 인지 |
| 연결 거부 refused | 백엔드가 켜졌는지, 포트가 `baseURL` 과 같은지 |

---

## 【Lab 4·선택】 `hooks/useTodos.js` 로 분리 (15분)

`src/hooks/useTodos.js`:

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

  const deleteTodo = async (id) => {
    await api.delete(`/todos/${id}`);
    await fetchTodos();
  };

  return { todos, loading, error, fetchTodos, createTodo, deleteTodo };
}
```

`App.js` 에서 상태·load 로직 빼고 `const { todos, loading, ... } = useTodos();` 형태로 붙인다 — **동작 동일하게 유지하면 성공.**

---

## 【Lab 5·선택】 에러 문장만 조금 예쁘게 (10분)

`api/axios.js` 맨 아래에:

```javascript
api.interceptors.response.use(
  (res) => res,
  (err) => {
    const status = err.response?.status;
    if (!err.response) {
      console.error('네트워크 또는 서버 꺼짐');
    } else {
      console.error('HTTP', status, err.response.data);
    }
    return Promise.reject(err);
  }
);
```

---

## 과제

- 세부 배점과 **비전공 최소 제출선**은 `exercises.md` 참고.

## 참고 (심화·혼자 볼 때)

- [Axios 문서](https://axios-http.com/)  
- [MDN — CORS](https://developer.mozilla.org/ko/docs/Web/HTTP/CORS)  
