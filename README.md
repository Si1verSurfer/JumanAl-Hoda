# جُمانُ الهُدَى

Landing page — React + Vite + TypeScript + Tailwind (repo root).

The Flutter app lives locally in `app/` (gitignored).

## Scripts

```bash
npm install
npm run dev
npm run build
```

Routes: `/` · `/privacy` · `/terms`

## Vercel

| Setting | Value |
|---------|--------|
| **Root Directory** | *(empty — repo root)* |
| **Build Command** | `npm run build` |
| **Output Directory** | `dist` |
| **Install Command** | `npm ci` |
| **Node.js** | **22.x** |

`vercel.json` is at the repo root.

## Mobile app (local)

```bash
cd app
flutter pub get
flutter run
```
