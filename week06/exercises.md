# 6주차 실습 과제 — React와 Spring Boot Todo API 연동

이번 과제는 5주차 Todo API를 React 화면에서 호출하는 것입니다.  
프론트와 백엔드를 동시에 실행하고, 브라우저 화면에서 API가 실제로 동작하는 것을 증명합니다.

---

## 제출용 전체 따라하기 순서

| 순서 | 해야 할 일 | 확인 방법 |
|------|------------|-----------|
| 1 | 백엔드 실행 | Postman `GET /api/todos` 성공 |
| 2 | CORS 설정 추가 | React 출처 `http://localhost:3000` 허용 |
| 3 | React 프로젝트 생성 | `npm start`로 화면 열림 |
| 4 | Axios 설치 | `package.json`에 `axios` 존재 |
| 5 | `src/api/axios.js` 작성 | `baseURL`이 `http://localhost:8080/api` |
| 6 | `App.js`에 목록 조회 작성 | 새로고침 시 GET 요청 발생 |
| 7 | 추가 기능 작성 | 버튼 클릭 시 POST 요청 발생 |
| 8 | 삭제 또는 완료 토글 작성 | DELETE 또는 PATCH 요청 발생 |
| 9 | 로딩/에러 문구 추가 | 실패 시 화면에 메시지 표시 |
| 10 | Network 탭 캡처 | 요청 URL과 Status가 보이게 캡처 |

### 중간 체크포인트

- **체크포인트 A**: 백엔드 단독 `GET /api/todos` 성공
- **체크포인트 B**: React 화면이 `localhost:3000`에서 열림
- **체크포인트 C**: Network 탭에서 `GET /api/todos` 요청 확인
- **체크포인트 D**: 추가 후 `POST /api/todos` 요청 확인
- **체크포인트 E**: 삭제 또는 완료 토글 요청 확인

---

## 제출 전제

백엔드에는 아래 API가 준비되어 있어야 합니다.

| 기능 | Method | URL |
|------|--------|-----|
| 목록 조회 | GET | `/api/todos` |
| 생성 | POST | `/api/todos` |
| 삭제 | DELETE | `/api/todos/{id}` |
| 완료 토글 | PATCH | `/api/todos/{id}/toggle` |

완료 토글 API가 없는 경우에는 목록 조회, 생성, 삭제까지 구현해도 됩니다.

---

## 1단계: CORS와 Axios 설정 (필수)

### 목표

React(`localhost:3000`)에서 Spring Boot(`localhost:8080`) API를 호출할 수 있게 만든다.

### 해야 할 일

1. Spring Boot에 `CorsConfig.java` 추가
2. React 프로젝트 생성
3. `axios` 설치
4. `src/api/axios.js` 작성
5. `baseURL`이 `http://localhost:8080/api`를 가리키는지 확인

### 제출물

- `CorsConfig.java`
- `src/api/axios.js`
- 백엔드/프론트 실행 명령을 적은 README

### 실패하면 먼저 볼 것

- CORS 에러면 백엔드를 재실행했는지 확인
- `Network Error`면 Spring Boot가 켜져 있는지 확인
- 404면 `baseURL` 끝에 `/api`가 들어갔는지 확인

---

## 2단계: Todo 목록 조회와 추가 (필수)

### 목표

브라우저에서 목록을 보고, 입력 후 추가 버튼으로 Todo를 생성한다.

### 요구사항

- 페이지가 열릴 때 `GET /todos` 호출
- 입력창에 제목을 입력하고 추가 버튼 클릭
- `POST /todos` 호출
- 성공 후 목록 갱신
- 로딩 중이거나 실패했을 때 화면에 문구 표시

### 제출물

- 화면 캡처: 목록과 새로 추가한 Todo가 보이는 화면
- Network 탭에서 `GET` 또는 `POST` 요청이 보이는 캡처

---

## 3단계: 삭제 또는 완료 토글 (필수 선택)

아래 중 하나 이상 구현합니다.

### A. 삭제

- 각 Todo 옆 삭제 버튼
- `DELETE /todos/{id}` 호출
- 성공 후 목록 갱신

### B. 완료 토글

- 각 Todo 옆 완료/미완료 버튼
- `PATCH /todos/{id}/toggle` 호출
- 성공 후 목록 갱신

### 제출물

- 삭제 또는 완료 토글 동작 화면 캡처

---

## 4단계: 커스텀 훅 분리 (선택)

### 목표

API 호출 로직을 `useTodos.js`로 분리한다.

### 요구사항

- `fetchTodos`
- `createTodo`
- `deleteTodo`
- `toggleTodo` 중 구현한 기능 포함
- `loading`, `error` 상태 포함

### 제출물

- `hooks/useTodos.js`
- 사용하는 컴포넌트 코드

---

## 5단계: 에러 처리와 인터셉터 (선택)

### 목표

요청 실패 상황을 개발자와 사용자 모두 확인할 수 있게 한다.

### 요구사항

- Axios 응답 인터셉터에서 에러 로그 출력
- 화면에 사용자 메시지 표시
- Network Error, CORS, 404 중 하나 이상을 README에 설명

---

## 평가 기준

| 항목 | 배점 | 평가 |
|------|------|------|
| 1단계 CORS/Axios | 20 | 백엔드 허용 설정, Axios 인스턴스 |
| 2단계 조회/추가 | 40 | 목록 표시, POST 성공, 목록 갱신 |
| 3단계 삭제/토글 | 25 | DELETE 또는 PATCH 연동 |
| 로딩/에러 UI | 10 | 사용자 메시지, 버튼 disabled 등 |
| README/제출 정리 | 5 | 실행 명령, 캡처, `node_modules` 제외 |

총점 100점.

---

## README에 꼭 적기

```bash
# 백엔드
./mvnw spring-boot:run

# 프론트엔드
npm install
npm start
```

추가로 적을 것:

- 백엔드 주소: `http://localhost:8080`
- 프론트 주소: `http://localhost:3000`
- 구현한 기능 목록
- 막혔던 오류와 해결 방법 1개 이상
- 캡처한 Network 요청 목록 (`GET`, `POST`, `DELETE` 또는 `PATCH`)

---

## 제출 주의

- `node_modules/`는 올리지 않는다.
- 실제 DB 비밀번호가 들어간 설정 파일은 올리지 않는다.
- 스크린샷은 기능이 실제로 동작하는 장면이어야 한다.
