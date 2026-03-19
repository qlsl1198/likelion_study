# HTML 슬라이드 생성 가이드

각 주차별 presentation.html 파일은 reveal.js를 사용하여 생성되었습니다.

## PDF로 변환하는 방법

### 방법 1: 브라우저에서 직접 인쇄
1. HTML 파일을 브라우저에서 엽니다
2. `Ctrl+P` (Windows) 또는 `Cmd+P` (Mac)를 눌러 인쇄 대화상자를 엽니다
3. 대상: "PDF로 저장" 선택
4. 레이아웃: "가로" 선택
5. 옵션에서 "배경 그래픽" 체크
6. 저장

### 방법 2: Reveal.js PDF 플러그인 사용
1. URL에 `?print-pdf` 추가: `file:///path/to/presentation.html?print-pdf`
2. 브라우저에서 인쇄 (Ctrl+P 또는 Cmd+P)
3. PDF로 저장

### 방법 3: Puppeteer 사용 (고급)
```bash
npm install -g reveal-md puppeteer
reveal-md presentation.html --print presentation.pdf
```

## 주의사항
- 각 슬라이드는 `<section>` 태그로 구분되어 있습니다
- PDF 변환 시 각 `<section>`이 한 페이지로 나뉩니다
- `@media print` CSS가 자동으로 페이지 브레이크를 추가합니다

