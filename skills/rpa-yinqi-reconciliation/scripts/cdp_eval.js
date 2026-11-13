// CDP 批量执行页面 JS。用法：CDP_PORT=9223 node cdp_eval.js steps.json
// steps.json = [{"name":"...", "js":"(() => {...})()", "sleep": 1500}, ...]
// 依赖 Node >= 22（内置全局 WebSocket）。目标：先用 /json/list 找到 url 含 rpaIndex 的 page。
const fs = require('fs');

const BASE = 'http://127.0.0.1:' + (process.env.CDP_PORT || '9223');
const URL_HINT = process.env.CDP_URL_HINT || 'rpaIndex';
const TITLE_HINT = process.env.CDP_TITLE_HINT || '';
const TARGET_ID = process.env.CDP_TARGET_ID || '';

async function connect(target) {
  const ws = new WebSocket(target.webSocketDebuggerUrl);
  await new Promise((res, rej) => {
    ws.onopen = res;
    ws.onerror = () => rej(new Error('WebSocket 握手失败（检查 --remote-allow-origins=*）'));
  });
  let id = 0;
  const pending = new Map();
  ws.onmessage = (ev) => {
    const msg = JSON.parse(ev.data);
    if (msg.id && pending.has(msg.id)) {
      const { res, rej } = pending.get(msg.id);
      pending.delete(msg.id);
      msg.error ? rej(new Error(JSON.stringify(msg.error))) : res(msg.result);
    }
  };
  const send = (method, params) => new Promise((res, rej) => {
    const mid = ++id;
    pending.set(mid, { res, rej });
    ws.send(JSON.stringify({ id: mid, method, params }));
  });
  return { ws, send };
}

(async () => {
  const steps = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
  let target = null;
  for (let i = 0; i < 90; i++) {
    try {
      const list = await (await fetch(BASE + '/json/list')).json();
      const hits = list.filter(t => t.type === 'page' && (TARGET_ID ? t.id === TARGET_ID : ((t.url || '').includes(URL_HINT) && (!TITLE_HINT || (t.title || '').includes(TITLE_HINT)))));
      target = process.env.CDP_PICK === 'last' ? hits[hits.length - 1] : hits[0];
      if (target) break;
    } catch (e) { /* 端口还没起来，继续等 */ }
    await new Promise(r => setTimeout(r, 1000));
  }
  if (!target) { console.log('NO TARGET FOUND（端口未开或页面未加载）'); process.exit(1); }

  const { ws, send } = await connect(target);
  for (const s of steps) {
    console.log('--- ' + (s.name || 'eval'));
    const r = await send('Runtime.evaluate', {
      expression: s.js, returnByValue: true, awaitPromise: true, userGesture: true,
    });
    if (r.exceptionDetails) {
      console.log('JS EXCEPTION: ' + JSON.stringify(r.exceptionDetails.exception || r.exceptionDetails));
    } else {
      const v = r.result.value;
      console.log(typeof v === 'string' ? v : JSON.stringify(v));
    }
    if (s.sleep) await new Promise(r2 => setTimeout(r2, s.sleep));
  }
  ws.close();
})();
