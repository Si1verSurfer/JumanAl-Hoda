# Deploy website to Vercel

This repo contains a Flutter app **and** a Vite website in `website/`.

## Quick fix for `404 NOT_FOUND`

`NOT_FOUND` on Vercel means **no files were published** (wrong folder or failed build).

### Recommended setup (choose ONE)

#### Option A — Deploy from repo root (easiest)

1. Vercel → **Project Settings → General → Root Directory**
2. Leave it **empty** (`.` / repository root)
3. **Save** and **Redeploy**

The root `vercel.json` builds `website/` and publishes `website/dist`.

#### Option B — Deploy only the website folder

1. Vercel → **Project Settings → General → Root Directory**
2. Set to: `website`
3. **Save** and **Redeploy**

`website/vercel.json` publishes `dist` relative to that folder.

### Clear bad overrides

In **Settings → Build & Deployment**:

- Remove any **Production Override** for Output Directory
- If Root Directory = `website` → Output Directory must be `dist`
- If Root Directory = empty → leave Output Directory blank (uses `website/dist` from root `vercel.json`)

### Expected build log

```
npm install --prefix website
npm run build --prefix website
vite build
```

Output must contain `website/dist/index.html` (root deploy) or `dist/index.html` (website root deploy).

### Custom domain

Point `jumanahjumanalhoda.com` to this Vercel project after a successful deployment.
