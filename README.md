# جُمانُ الهُدَى

React landing site in `web/` — deployed on Vercel. Flutter app in `app/` is local only.

## Repo layout

```
├── web/              # Website (on GitHub, deployed to Vercel)
├── app/              # Flutter mobile app (gitignored, local only)
├── vercel.json       # Builds from web/ at deploy time
└── README.md
```

## Develop locally

```bash
cd web
npm install
npm run dev
```

Routes: `/` · `/privacy` · `/terms`

## Vercel (automatic)

Root `vercel.json` runs:

- `cd web && npm ci`
- `cd web && npm run build`
- output: `web/dist`

**Root Directory** in Vercel should stay **empty** (repo root). Both projects (`juman-al-hoda`, `juman-al-hoda-ms1b`) use this config.

Production URLs:

- https://juman-al-hoda.vercel.app
- https://juman-al-hoda-ms1b.vercel.app

## Mobile app (local)

```bash
cd app
flutter pub get
flutter run
```
