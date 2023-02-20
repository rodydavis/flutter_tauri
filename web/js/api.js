var d = Object.defineProperty, e = (t, n) => {
  for (var r in n)
    d(t, r, { get: n[r], enumerable: !0 });
}, f = {};
e(f, { convertFileSrc: () => w, invoke: () => c, transformCallback: () => s });
function u() {
  return window.crypto.getRandomValues(new Uint32Array(1))[0];
}
function s(t, n = !1) {
  let r = u(), o = `_${r}`;
  return Object.defineProperty(window, o, { value: (i) => (n && Reflect.deleteProperty(window, o), t == null ? void 0 : t(i)), writable: !1, configurable: !0 }), r;
}
async function c(t, n = {}) {
  return new Promise((r, o) => {
    let i = s((l) => {
      r(l), Reflect.deleteProperty(window, `_${a}`);
    }, !0), a = s((l) => {
      o(l), Reflect.deleteProperty(window, `_${i}`);
    }, !0);
    window.__TAURI_IPC__({ cmd: t, callback: i, error: a, ...n });
  });
}
function w(t, n = "asset") {
  let r = encodeURIComponent(t);
  return navigator.userAgent.includes("Windows") ? `https://${n}.localhost/${r}` : `${n}://localhost/${r}`;
}
function invokeRust(t, n) {
  return c(t, JSON.parse(n));
}
function evalJs(js) {
  return eval(js);
}
window.invokeRust = invokeRust;
window.evalJs = evalJs;
