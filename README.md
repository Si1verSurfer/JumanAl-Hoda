# جُمانُ الهُدَى

Landing page — React + Vite + TypeScript + Tailwind.

The Flutter mobile app lives locally in `app/` (gitignored, not pushed to GitHub).

## Structure

```
├── public/
├── src/
│   ├── components/
│   ├── pages/
│   ├── data/
│   ├── config/
│   ├── App.tsx
│   ├── main.tsx
│   └── index.css
├── index.html
├── vite.config.ts
├── vercel.json
└── package.json
```

## Scripts

```bash
npm install
npm run dev
npm run build
```

## Vercel deploy

| Setting | Value |
|---------|--------|
| **Application Preset** | **Vite** |
| **Root Directory** | *(leave empty)* |
| **Build Command** | `npm run build` |
| **Output Directory** | `dist` |
| **Install Command** | `npm ci` |
| **Node.js Version** | **22.x** |

`vercel.json` is configured for SPA routing (`/privacy`, `/terms`).

## Routes

- `/` — Landing
- `/privacy` — سياسة الخصوصية
- `/terms` — الشروط والأحكام

## Local mobile app

```bash
cd app
flutter pub get
flutter run
```
