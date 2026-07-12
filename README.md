# جُمانُ الهُدَى

Landing page — React + Vite + TypeScript + Tailwind.

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

**Important:** Remove any Production Overrides in Build settings, then redeploy.

`vercel.json` is already configured for SPA routing (`/privacy`, `/terms`).

## Routes

- `/` — Landing
- `/privacy` — سياسة الخصوصية
- `/terms` — الشروط والأحكام
