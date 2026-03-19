# 2주차 보조 자료

## React 개발 도구

### React Developer Tools
- 브라우저 확장 프로그램 설치
- Chrome: [Chrome Web Store](https://chrome.google.com/webstore)
- Firefox: [Firefox Add-ons](https://addons.mozilla.org/)
- 컴포넌트 트리, Props, State 확인 가능

## JSX 상세 가이드

### 조건부 렌더링
```jsx
// 방법 1: 삼항 연산자
function Greeting({ isLoggedIn }) {
    return (
        <div>
            {isLoggedIn ? <h1>Welcome back!</h1> : <h1>Please log in.</h1>}
        </div>
    );
}

// 방법 2: 논리 연산자 (&&)
function Mailbox({ unreadMessages }) {
    return (
        <div>
            <h1>Hello!</h1>
            {unreadMessages.length > 0 && (
                <h2>You have {unreadMessages.length} unread messages.</h2>
            )}
        </div>
    );
}

// 방법 3: 즉시 실행 함수
function ItemList({ items }) {
    return (
        <div>
            {(() => {
                if (items.length === 0) return <p>No items</p>;
                return items.map(item => <div key={item.id}>{item.name}</div>);
            })()}
        </div>
    );
}
```

### 리스트 렌더링
```jsx
function TodoList({ todos }) {
    return (
        <ul>
            {todos.map(todo => (
                <li key={todo.id}>{todo.text}</li>
            ))}
        </ul>
    );
}

// key의 중요성
// - React가 어떤 항목이 변경되었는지 식별
// - 고유한 값 사용 (id 등)
// - 배열 인덱스는 피하는 것이 좋음
```

## Props 고급 사용법

### PropTypes (타입 검증)
```jsx
import PropTypes from 'prop-types';

function Greeting({ name, age }) {
    return (
        <div>
            <h1>Hello, {name}!</h1>
            <p>Age: {age}</p>
        </div>
    );
}

Greeting.propTypes = {
    name: PropTypes.string.isRequired,
    age: PropTypes.number
};

Greeting.defaultProps = {
    age: 0
};
```

### Props 전달 패턴
```jsx
// Props 전개 연산자
function Button({ type, children, ...rest }) {
    return (
        <button type={type} {...rest}>
            {children}
        </button>
    );
}

// 사용
<Button type="submit" className="btn" onClick={handleClick}>
    Submit
</Button>
```

## State 관리 패턴

### State 끌어올리기 (Lifting State Up)
```jsx
// 자식 컴포넌트
function TemperatureInput({ temperature, scale, onTemperatureChange }) {
    return (
        <div>
            <input
                value={temperature}
                onChange={(e) => onTemperatureChange(e.target.value, scale)}
            />
            <span>{scale === 'c' ? 'Celsius' : 'Fahrenheit'}</span>
        </div>
    );
}

// 부모 컴포넌트
function Calculator() {
    const [temperature, setTemperature] = useState('');
    const [scale, setScale] = useState('c');
    
    const handleTemperatureChange = (value, scale) => {
        setTemperature(value);
        setScale(scale);
    };
    
    return (
        <div>
            <TemperatureInput
                temperature={temperature}
                scale="c"
                onTemperatureChange={handleTemperatureChange}
            />
            <TemperatureInput
                temperature={temperature}
                scale="f"
                onTemperatureChange={handleTemperatureChange}
            />
        </div>
    );
}
```

### State 업데이트 주의사항
```jsx
// ❌ 잘못된 방법 - 직접 수정
const [items, setItems] = useState([1, 2, 3]);
items.push(4);  // State 직접 수정 금지!

// ✅ 올바른 방법 - 새 배열 생성
setItems([...items, 4]);

// 배열 업데이트
setItems(items.map(item => 
    item.id === id ? { ...item, completed: true } : item
));

// 객체 업데이트
setUser({ ...user, name: 'New Name' });
```

## 이벤트 처리 고급

### 이벤트 핸들러에 매개변수 전달
```jsx
function ItemList({ items }) {
    const handleClick = (id) => {
        console.log('Item clicked:', id);
    };
    
    return (
        <ul>
            {items.map(item => (
                <li key={item.id}>
                    <button onClick={() => handleClick(item.id)}>
                        {item.name}
                    </button>
                </li>
            ))}
        </ul>
    );
}
```

### 커스텀 이벤트
```jsx
function CustomButton({ onClick, children }) {
    const handleClick = (e) => {
        e.preventDefault();
        onClick(e);
    };
    
    return <button onClick={handleClick}>{children}</button>;
}
```

## 컴포넌트 설계 원칙

### 단일 책임 원칙
- 각 컴포넌트는 하나의 명확한 목적만 가져야 함
- 너무 큰 컴포넌트는 작은 컴포넌트로 분리

### 컴포넌트 분리 기준
1. 재사용 가능한가?
2. 독립적으로 테스트 가능한가?
3. 단일 책임을 가지는가?

### 예시: 큰 컴포넌트를 작은 컴포넌트로 분리
```jsx
// ❌ 하나의 큰 컴포넌트
function UserProfile({ user }) {
    return (
        <div>
            <img src={user.avatar} alt={user.name} />
            <h1>{user.name}</h1>
            <p>{user.bio}</p>
            <button>Follow</button>
            <div>
                <h2>Posts</h2>
                {user.posts.map(post => (
                    <div key={post.id}>
                        <h3>{post.title}</h3>
                        <p>{post.content}</p>
                    </div>
                ))}
            </div>
        </div>
    );
}

// ✅ 작은 컴포넌트로 분리
function Avatar({ src, alt }) {
    return <img src={src} alt={alt} />;
}

function UserInfo({ name, bio }) {
    return (
        <div>
            <h1>{name}</h1>
            <p>{bio}</p>
        </div>
    );
}

function FollowButton() {
    return <button>Follow</button>;
}

function PostList({ posts }) {
    return (
        <div>
            <h2>Posts</h2>
            {posts.map(post => (
                <Post key={post.id} post={post} />
            ))}
        </div>
    );
}

function UserProfile({ user }) {
    return (
        <div>
            <Avatar src={user.avatar} alt={user.name} />
            <UserInfo name={user.name} bio={user.bio} />
            <FollowButton />
            <PostList posts={user.posts} />
        </div>
    );
}
```

## 성능 최적화 기초

### 불필요한 리렌더링 방지
```jsx
// 함수를 컴포넌트 외부로 이동
const handleClick = () => {
    console.log('Clicked');
};

function Button() {
    return <button onClick={handleClick}>Click</button>;
}

// 또는 useCallback 사용 (다음 주차에서 학습)
```

## 실전 팁

### 네이밍 컨벤션
- 컴포넌트: PascalCase (예: `UserProfile`)
- 함수/변수: camelCase (예: `handleClick`)
- 상수: UPPER_SNAKE_CASE (예: `MAX_COUNT`)

### 파일 구조
```
src/
├── components/
│   ├── Button/
│   │   ├── Button.js
│   │   ├── Button.css
│   │   └── index.js
│   └── Header/
│       ├── Header.js
│       └── index.js
├── App.js
└── index.js
```

### CSS 모듈 사용
```jsx
// Button.module.css
.button {
    background-color: blue;
    color: white;
}

// Button.js
import styles from './Button.module.css';

function Button() {
    return <button className={styles.button}>Click</button>;
}
```

