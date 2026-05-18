# 6주차 보조 자료 — React와 Spring Boot API 연동 치트시트

강의 흐름은 `presentation.html`과 `presentation.md`를 기준으로 합니다. 이 파일은 복붙용 코드와 디버깅 체크리스트입니다.

---

## 0. 처음부터 끝까지 타이핑 순서

1. 백엔드 프로젝트에서 `./mvnw spring-boot:run`
2. Postman으로 `GET http://localhost:8080/api/todos`
3. 백엔드에 `config/CorsConfig.java` 추가
4. 백엔드 재실행
5. React 프로젝트 생성
6. `npm install axios`
7. `src/api/axios.js` 작성
8. `src/App.js`에서 목록 조회 구현
9. 추가 기능 구현
10. 삭제 또는 완료 토글 구현
11. Chrome Network 탭에서 요청 확인
12. 필요하면 `src/hooks/useTodos.js`로 분리

### 다음 단계로 넘어가기 전 확인

- 백엔드 단독 API가 실패하면 React를 고치지 않는다.
- React 화면은 뜨는데 목록이 안 나오면 Network 탭을 본다.
- Network에 요청 자체가 없으면 React 이벤트/함수 호출을 확인한다.
- 요청은 있는데 실패하면 Status Code와 Response를 본다.

---

## 1. Spring CORS 설정

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

React가 Vite로 `5173` 포트에서 뜨면 `http://localhost:5173`도 허용해야 합니다.

---

## 2. React 프로젝트 생성

```bash
npx create-react-app todo-front
cd todo-front
npm install axios
npm start
```

---

## 3. `src/api/axios.js`

```javascript
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8080/api',
  headers: { 'Content-Type': 'application/json' },
  timeout: 10000,
});

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

export default api;
```

---

## 4. API 호출 조각

```javascript
const res = await api.get('/todos');
```

```javascript
await api.post('/todos', {
  title: 'React에서 추가',
  description: '',
});
```

```javascript
await api.patch(`/todos/${id}/toggle`);
```

```javascript
await api.delete(`/todos/${id}`);
```

---

## 5. `useTodos.js`

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

## 6. 디버깅 순서

1. 백엔드 단독 확인: `GET http://localhost:8080/api/todos`
2. React 실행 확인: `http://localhost:3000`
3. Chrome DevTools → Network 탭
4. Request URL이 `http://localhost:8080/api/todos`인지 확인
5. Status Code 확인
6. Console에 CORS/Network 에러 확인

### Status Code 빠른 해석

| Status | 의미 | 다음 행동 |
|--------|------|-----------|
| 200 | 조회 성공 | 화면 state 업데이트 확인 |
| 201 | 생성 성공 | 목록 다시 불러오기 확인 |
| 204 | 삭제 성공 | 목록에서 사라졌는지 확인 |
| 400 | 요청 body 문제 | `title` 값 확인 |
| 404 | URL 문제 | `/api`와 컨트롤러 경로 확인 |
| 500 | 서버 내부 에러 | Spring Boot 터미널 로그 확인 |

---

## 7. 오류 대응표

| 증상 | 원인 | 해결 |
|------|------|------|
| CORS 에러 | 서버가 React 출처를 허용하지 않음 | `CorsConfig` 확인 후 백엔드 재실행 |
| Network Error | 백엔드 꺼짐 또는 포트 불일치 | Spring 서버, `baseURL` 확인 |
| 404 | URL 경로 틀림 | `baseURL` 끝의 `/api` 확인 |
| 400 | POST body 부족 | `title` 값 확인 |
| 버튼 여러 번 클릭 | 중복 요청 | `disabled`, `workingId` 사용 |

---

## 8. 제출 체크

- 화면에서 목록 조회
- 추가 버튼으로 POST 성공
- 삭제 또는 완료 토글 중 하나 이상 성공
- Network 탭에서 200/201/204 요청 확인
- README에 백엔드/프론트 실행 명령 작성
- `node_modules/` 제외
