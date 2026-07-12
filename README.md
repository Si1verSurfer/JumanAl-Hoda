# جُمانُ الهُدَى — Local project layout

This folder is organized for **local development on your device only**. The `app/` and `web/` directories are gitignored and are not pushed to GitHub.

## Structure

```
goman_alhoda/
├── app/          # Flutter mobile app (iOS & Android)
│   ├── lib/
│   ├── android/
│   ├── ios/
│   ├── assets/
│   ├── packages/
│   └── pubspec.yaml
└── web/          # React landing site (Vite + Tailwind)
    ├── src/
    ├── public/
    └── package.json
```

## Mobile app — legal documents

Privacy policy and terms & conditions are included in the app under **Settings → Legal**, using the same Arabic content as the website (`web/src/data/legal.ts` ↔ `app/lib/features/settings/data/legal_documents.dart`).

## Run the website

```bash
cd web
npm install
npm run dev
```

Routes: `/` (landing), `/privacy`, `/terms`

## Run the mobile app

```bash
cd app
flutter pub get
flutter run
```

## Notes

- GitHub tracks only the root README and `.gitignore` for this local layout.
- Restore or update the Flutter app from local backups if needed; full source lives in `app/`.
