# 6주차 보조 자료 (복붙용)

강의 흐름은 **`presentation.md`** 기준입니다. 여기서는 빠르게 다시 고칠 때 쓰는 조각만 모았습니다.

---

## Spring CORS (최소)

```java
registry.addMapping("/api/**")
    .allowedOrigins("http://localhost:3000")
    .allowedMethods("GET","POST","PUT","PATCH","DELETE","OPTIONS")
    .allowedHeaders("*");
```

---

## Axios 인스턴스

```javascript
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8080/api',
  timeout: 10000,
});
export default api;
```

---

## React에서 한 번 호출

```javascript
const res = await api.get('/todos');
console.log(res.data);
```

---

## 환경 변수 (선택, CRA)

`.env.development`:

```env
REACT_APP_API_BASE=http://localhost:8080/api
```

코드에서:

```javascript
axios.create({
  baseURL: process.env.REACT_APP_API_BASE,
});
```

---

## 자주 하는 실수

- 백엔드 **패스**가 `/api/todos` 인데 Axios에서 `/todos`만 쓸 때 — `baseURL` 끝에 `/api` 포함 여부 확인  
- **프록시**(package.json `"proxy"` ) 쓸 때와 **절대 URL** 쓸 때 섞음 — 수업에서는 **절대 URL + CORS** 한 가지로 통일 추천  

---

## 디버깅 순서

1. 백엔드 단독: Postman으로 `GET http://localhost:8080/api/todos`  
2. 브라우저 Network: 요청 나갔는지, 빨간지  
3. CORS 에러 문구 나오면 백엔드 `allowedOrigins` 수정  
