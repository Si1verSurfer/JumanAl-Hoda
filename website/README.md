# جُمانُ الهُدَى — Website

Landing page and legal pages for the iOS app.

## Local development

```bash
npm install
npm run dev
```

Open http://localhost:5173

## Deploy on Vercel

| Setting | Value |
|---------|--------|
| **Application Preset** | **Vite** |
| **Root Directory** | `website` |
| **Build Command** | `npm run build` |
| **Output Directory** | `dist` |
| **Node.js** | 22.x |

Remove any **Production Overrides** in Build settings, then redeploy.

## Routes

- `/` — Landing page
- `/privacy` — Privacy policy
- `/terms` — Terms & conditions

The iOS app loads `/privacy?embed=1` and `/terms?embed=1` from the deployed site.
