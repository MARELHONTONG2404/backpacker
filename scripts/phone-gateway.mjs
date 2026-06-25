/**
 * Gateway satu port untuk akses mobile dari HP.
 * UI Flutter (8888) + API backend (8080) lewat port 9000.
 */
import http from 'node:http';

const MOBILE_PORT = 8889;
const API_PORT = 8080;
const GATEWAY_PORT = 8888;

const API_PREFIXES = ['/backpacker', '/captchaImage', '/common', '/login', '/getInfo', '/logout'];

function targetPort(url) {
  const path = url.split('?')[0] || '/';
  return API_PREFIXES.some((p) => path.startsWith(p)) ? API_PORT : MOBILE_PORT;
}

function proxy(req, res) {
  const port = targetPort(req.url || '/');
  const upstream = http.request(
    {
      hostname: '127.0.0.1',
      port,
      path: req.url,
      method: req.method,
      headers: {
        ...req.headers,
        host: `127.0.0.1:${port}`,
      },
    },
    (up) => {
      res.writeHead(up.statusCode || 502, up.headers);
      up.pipe(res);
    },
  );
  upstream.on('error', () => {
    if (!res.headersSent) {
      res.writeHead(502, { 'Content-Type': 'text/plain; charset=utf-8' });
    }
    res.end(`Gateway error: layanan port ${port} tidak aktif.`);
  });
  req.pipe(upstream);
}

http.createServer(proxy).listen(GATEWAY_PORT, '0.0.0.0', () => {
  console.log(`Phone gateway aktif: http://0.0.0.0:${GATEWAY_PORT}`);
  console.log('  HP (satu URL): http://IP-PC-ANDA:8888');
});
