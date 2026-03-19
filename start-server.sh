#!/bin/bash
# 맥북 서버: 멋쟁이사자처럼 풀스택 강의 자료
# 대구에 둔 맥북 → 서울/전 세계 어디서든 접속 가능 (ngrok 터널)

cd "$(dirname "$0")"
PORT=3000

cleanup() {
    echo ""
    echo "서버를 종료합니다."
    kill $SERVER_PID 2>/dev/null
    exit 0
}
trap cleanup SIGINT SIGTERM

# 포트가 이미 사용 중이면 기존 프로세스 종료
if lsof -ti:$PORT >/dev/null 2>&1; then
    echo "⚠️  포트 $PORT 사용 중인 프로세스를 종료합니다."
    lsof -ti:$PORT | xargs kill -9 2>/dev/null
    sleep 1
fi

echo "🖥️  맥북 서버 시작 (포트 $PORT)"
echo "   - 로컬: http://localhost:$PORT"
echo "   - 같은 WiFi: http://$(ipconfig getifaddr en0 2>/dev/null || hostname):$PORT"
echo ""

# Python HTTP 서버 (이 맥북이 서버)
python3 -m http.server $PORT --bind 0.0.0.0 &
SERVER_PID=$!

sleep 2

echo "🌐 Cloudflare 터널 생성 중..."
echo "   → 아래 https://xxx.trycloudflare.com URL로 서울/전 세계 어디서든 접속 가능"
echo "   → 가입 없이 동작"
echo ""

cloudflared tunnel --url http://localhost:$PORT

cleanup
