# جُمانُ الهُدَى — Website

Landing page for **جُمانُ الهُدَى** (React + Vite + TypeScript + Tailwind).

## Project structure

```
├── public/          Static assets (icons, mockups, manifest)
├── src/
│   ├── components/  UI components (Hero, Navbar, Footer, …)
│   ├── pages/       Route pages (Home, Privacy, Terms, 404)
│   ├── data/        Content & legal copy (Arabic)
│   ├── config/      Site URL & metadata
│   ├── App.tsx      Router
│   ├── main.tsx     Entry point
│   └── index.css    Tailwind & brand styles
├── index.html
├── vite.config.ts
├── vercel.json      SPA routing & headers
└── package.json
```

## Development

```bash
npm install
npm run dev
```

Open http://localhost:5173

## Build

```bash
npm run build
npm run preview
```

## Deploy on Vercel

| Setting | Value |
|---------|--------|
| **Application Preset** | **Vite** |
| **Root Directory** | *(empty — repo root)* |
| **Build Command** | `npm run build` |
| **Output Directory** | `dist` |
| **Node.js** | 22.x |

## Routes

| Path | Page |
|------|------|
| `/` | Landing page |
| `/privacy` | سياسة الخصوصية |
| `/terms` | الشروط والأحكام |

The iOS app loads legal pages from the deployed site with `?embed=1`.

## Mobile app

The Flutter app is kept locally in `mobile/` (not in this repo).
