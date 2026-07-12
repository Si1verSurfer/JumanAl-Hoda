# جُمانُ الهُدَى

Landing page — React + Vite + TypeScript + Tailwind.

| Path | On GitHub | Notes |
|------|-----------|--------|
| `web/` | Yes | Website source — deployed via Vercel |
| `app/` | No | Flutter mobile app (local only, gitignored) |

## Website (`web/`)

```bash
cd web
npm install
npm run dev
npm run build
```

Routes: `/` (landing), `/privacy`, `/terms`

## Vercel deploy

The repo includes a root `vercel.json` that builds from `web/` automatically.

You can also set **Root Directory** to `web` in Vercel (Settings → General) and use `web/vercel.json` instead — either approach works.

## Mobile app (`app/` — local only)

```bash
cd app
flutter pub get
flutter run
```
