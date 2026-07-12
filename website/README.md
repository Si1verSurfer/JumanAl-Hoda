# جُمانُ الهُدَى — Website

Landing page and legal pages for the **جُمانُ الهُدَى** iOS app.

## Deploy on Vercel

1. Push this repository to GitHub.
2. In [Vercel](https://vercel.com), create a **New Project** and import the repo.
3. Set **Root Directory** to `website`.
4. Vercel auto-detects **Vite** — keep these settings:
   - **Build Command:** `npm run build`
   - **Output Directory:** `dist`
   - **Install Command:** `npm install`
5. Add your custom domain: `jumanahjumanalhoda.com`
6. Deploy.

`vercel.json` is already configured for SPA routing (`/privacy`, `/terms`, etc.).

## Local development

```bash
cd website
npm install
npm run dev
```

Open http://localhost:5173

## Production build

```bash
npm run build
npm run preview
```

## Routes

| Path | Page |
|------|------|
| `/` | Landing page |
| `/privacy` | Privacy policy |
| `/terms` | Terms & conditions |

The Flutter app loads legal pages from the deployed site with `?embed=1`.
