## Deploy on Vercel

See **[../DEPLOY.md](../DEPLOY.md)** in the repo root for the full troubleshooting guide.

### If Root Directory = `website`

| Setting | Value |
|---------|-------|
| Framework | Vite |
| Build Command | `npm run build` |
| Output Directory | `dist` |
| Node.js | 22.x |

### If Root Directory is empty (repo root)

Leave dashboard build settings blank — root `vercel.json` handles everything.
