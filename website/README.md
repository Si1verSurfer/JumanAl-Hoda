# جُمانُ الهُدَى — Website

Landing page and legal pages for the **جُمانُ الهُدَى** iOS app.

## Deploy on Vercel

### Option A — Deploy from repo root (recommended)

The repo includes a root `vercel.json` that builds the `website/` folder automatically.
Import **Si1verSurfer/JumanAl-Hoda** in Vercel and deploy with default settings.

### Option B — Deploy only the website folder

1. In Vercel project settings, set **Root Directory** to `website`.
2. Keep:
   - **Build Command:** `npm run build`
   - **Output Directory:** `dist`

### After deploy

Add your custom domain: `jumanahjumanalhoda.com`

If you see `404: NOT_FOUND`, redeploy after pulling the latest `main` branch.

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
