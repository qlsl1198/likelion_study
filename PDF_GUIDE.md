# PDF 변환 가이드

각 주차별 `presentation.html` 파일을 PDF로 변환하는 방법입니다.

## 방법 1: 브라우저 인쇄 기능 사용 (가장 간단)

1. HTML 파일을 브라우저에서 엽니다
   - Chrome, Edge, Firefox 등 모든 브라우저에서 가능
   - 파일을 더블클릭하거나 브라우저로 드래그

2. 인쇄 대화상자 열기
   - Windows: `Ctrl + P`
   - Mac: `Cmd + P`

3. 설정 변경
   - **대상**: "PDF로 저장" 선택
   - **레이아웃**: "가로" 선택 (Landscape)
   - **옵션**: "배경 그래픽" 체크 (중요!)
   - **여백**: "없음" 또는 "최소" 선택

4. 저장
   - "저장" 버튼 클릭
   - 파일명 입력 후 저장

## 방법 2: Reveal.js PDF 모드 사용

1. HTML 파일을 브라우저에서 엽니다

2. URL에 `?print-pdf` 추가
   ```
   file:///path/to/week01/presentation.html?print-pdf
   ```

3. 인쇄 (Ctrl+P 또는 Cmd+P)

4. PDF로 저장

## 방법 3: 명령줄 도구 사용 (고급)

### reveal-md 사용
```bash
npm install -g reveal-md
reveal-md week01/presentation.html --print week01.pdf
```

### Puppeteer 사용
```bash
npm install -g @slidev/cli
# 또는 직접 Puppeteer 스크립트 작성
```

## 주의사항

- ✅ 각 슬라이드는 `<section>` 태그로 구분되어 있습니다
- ✅ PDF 변환 시 각 `<section>`이 한 페이지로 나뉩니다
- ✅ 코드 블록은 자동으로 하이라이팅됩니다
- ✅ 배경색과 스타일이 제대로 표시되려면 "배경 그래픽" 옵션을 켜야 합니다

## 문제 해결

### 슬라이드가 잘리는 경우
- 브라우저의 확대/축소를 100%로 설정
- 여백을 "없음"으로 설정
- 페이지 크기를 A4 가로로 설정

### 코드가 잘 보이지 않는 경우
- "배경 그래픽" 옵션 확인
- 다크 테마 코드 블록의 경우 배경색이 중요합니다

### 슬라이드가 여러 페이지로 나뉘는 경우
- 정상 동작입니다. 각 `<section>`이 한 페이지입니다
- 하나의 슬라이드를 여러 페이지로 나누려면 `<section>`을 분리하세요

