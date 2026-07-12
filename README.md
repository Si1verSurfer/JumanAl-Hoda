# جُمانُ الهُدَى

This repository contains the **website only** (landing page + legal pages).

The Flutter iOS app lives locally in `mobile/` and is **not** pushed to GitHub.

## Website (deployed on Vercel)

```bash
cd website
npm install
npm run dev
```

### Vercel settings

| Setting | Value |
|---------|--------|
| **Application Preset** | Vite |
| **Root Directory** | `website` |
| **Build Command** | `npm run build` |
| **Output Directory** | `dist` |
| **Node.js** | 22.x |

## Mobile app (local only)

```bash
cd mobile
flutter pub get
./scripts/fetch_quran_assets.sh   # first time
flutter run
```

The `mobile/` folder is gitignored. Keep your own backup or a separate private repo for the app.
