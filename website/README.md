## Deploy on Vercel (required settings)

### 1. Import the repo
Import **Si1verSurfer/JumanAl-Hoda** on Vercel.

### 2. Set Root Directory — IMPORTANT
In **Project Settings → General → Root Directory**, set:

```
website
```

Click **Save**, then redeploy.

### 3. Build settings (should auto-fill from `vercel.json`)
| Setting | Value |
|---------|-------|
| Framework Preset | Vite |
| Build Command | `npm run build` |
| Output Directory | `dist` |
| Install Command | `npm install` |
| Node.js Version | 22.x |

### 4. Clear overrides
In **Settings → Build & Deployment**, remove any **Production Overrides** for Output Directory or Build Command if they exist.

### 5. Custom domain
Add `jumanahjumanalhoda.com` under **Domains**.

### Troubleshooting
- `404 NOT_FOUND` → Root Directory is not set to `website`
- `Deployment failed` → Check build logs; ensure Node 22 and Root Directory = `website`
- After changing Root Directory, click **Redeploy** on the latest deployment
