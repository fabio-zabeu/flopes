// Flopes: guarda o app no aparelho para abrir mesmo sem internet.
// Sempre tenta buscar a versão mais nova; usa a cópia guardada só quando não há internet.
// Os dados não passam por aqui: ficam no banco (Supabase) e no aparelho.
const CACHE = 'flopes-app-v3';
self.addEventListener('install', e => { self.skipWaiting(); });
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.hostname.endsWith('supabase.co')) return; // dados e fotos: sempre direto
  const cacheable = url.origin === location.origin || ['cdn.jsdelivr.net', 'fonts.googleapis.com', 'fonts.gstatic.com'].includes(url.hostname);
  if (!cacheable) return;
  const isPage = req.mode === 'navigate';
  e.respondWith(fetch(req).then(r => {
    if (r.ok) { const cp = r.clone(); caches.open(CACHE).then(c => c.put(isPage ? './' : req, cp)); }
    return r;
  }).catch(() => caches.match(isPage ? './' : req, { ignoreSearch: !isPage }).then(hit => hit || (isPage ? caches.match('./index.html') : undefined))));
});
