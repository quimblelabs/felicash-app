# Self-Hosting FeliCash

This guide helps you set up your own FeliCash backend and run the app with your own infrastructure.

## 📑 Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Backend Setup](#backend-setup)
- [Configuration](#configuration)
- [Running the App](#running-the-app)
- [Optional Services](#optional-services)

## 🎯 Overview

FeliCash is designed to be self-hosted. You own your data and can run everything on free tiers of popular cloud services.

### What You'll Need

| Service | Purpose | Free Tier Available | Required |
|---------|---------|---------------------|----------|
| **Supabase** | Database & Authentication | ✅ Yes | Required |
| **Firebase** | Push Notifications, Analytics | ✅ Yes | Optional |
| **PowerSync** | Offline Sync | ✅ Yes | Optional |
| **n8n** | AI Workflows | ✅ Self-hostable | Optional |

## 🚀 Quick Start

### 1. Fork & Clone

```bash
git clone https://github.com/YOUR_USERNAME/felicash-app.git
cd felicash-app
```

### 2. Set Up Supabase (Required)

1. Create a free account at [supabase.com](https://supabase.com)
2. Create a new project
3. Apply the [database schema](#database-schema) to your Supabase project
4. Copy your Project URL and Anon Key from Project Settings > API

### 3. Configure Environment

```bash
cp configurations.example.json configurations.dev.json
# Edit configurations.dev.json with your Supabase credentials
```

### 4. Run the App

```bash
flutter run --flavor development --target lib/main/main_development.dart --dart-define-from-file configurations.dev.json
```

## 🗄️ Backend Setup

### Database Schema

Use your Supabase schema export or migration scripts as the source of truth.
The current backend schema contains these public tables:

- `ai_logs`
- `ai_queries`
- `ai_query_type`
- `ai_transaction_documents`
- `budget_trackings`
- `budgets`
- `categories`
- `credit_wallets`
- `exchange_rates`
- `lending_borrowing_transactions`
- `merchants`
- `payback_links`
- `profiles`
- `recurrences`
- `savings_wallets`
- `transactions`
- `user_settings`
- `wallets`

Important enum-backed columns (USER-DEFINED):

- `budgets.budget_budget_period`
- `categories.category_transaction_type`
- `recurrences.recurrence_recurrence_type`
- `transactions.transaction_transaction_type`
- `wallets.wallet_wallet_type`

After applying schema, verify required tables exist:

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
```

Then ensure Row Level Security policies are enabled for user-owned data tables.

### Authentication Setup

1. Go to **Authentication > Providers** in Supabase Dashboard
2. Enable desired providers:
   - **Email** (enabled by default)
   - **Google** - Add your OAuth credentials
   - **Apple** - For iOS (configure in Apple Developer Portal)

## ⚙️ Configuration

### Required Variables

Copy `configurations.example.json` and fill in:

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key",
  "FELICASH_LOCAL_DB_NAME": "felicash.db"
}
```

Get these from **Supabase Dashboard > Project Settings > API**.

### Optional Variables

| Variable | Purpose | How to Get |
|----------|---------|------------|
| `POWERSYNC_URL` | Offline sync | [PowerSync Dashboard](https://powersync.com) |
| `N8N_BASE_URL` | AI features | Self-host n8n or use cloud |
| `OPENAI_BASE_URL` | OpenAI endpoint | [OpenAI Platform](https://platform.openai.com) |
| `OPENAI_API_KEY` | AI features | [OpenAI Platform](https://platform.openai.com) |
| `ELEVENLABS_BASE_URL` | ElevenLabs endpoint | [ElevenLabs](https://elevenlabs.io) |
| `ELEVENLABS_API_KEY` | Text-to-speech | [ElevenLabs](https://elevenlabs.io) |
| `IOS_CLIENT_ID` | Google Sign-In (iOS) | [Google Cloud Console](https://console.cloud.google.com) |
| `WEB_CLIENT_ID` | Google Sign-In (Web) | [Google Cloud Console](https://console.cloud.google.com) |

## 🏃 Running the App

### Development

```bash
flutter run --flavor development --target lib/main/main_development.dart --dart-define-from-file configurations.dev.json
```

### Production Build

```bash
# Android
flutter build apk --flavor production --target lib/main/main_production.dart --dart-define-from-file configurations.prod.json

# iOS
flutter build ios --flavor production --target lib/main/main_production.dart --dart-define-from-file configurations.prod.json
```

## 🔌 Optional Services

### PowerSync (Offline Support)

1. Create account at [powersync.com](https://powersync.com)
2. Connect your Supabase database
3. Add sync rules for user-scoped finance tables.

Example bucket definition:

```yaml
bucket_definitions:
  user_data:
    parameters:
      - SELECT request.user_id() AS user_id
    data:
      - SELECT * FROM wallets WHERE user_id = bucket.user_id
      - SELECT * FROM categories WHERE user_id = bucket.user_id
      - SELECT * FROM transactions WHERE user_id = bucket.user_id
      - SELECT * FROM recurrences WHERE recurrence_user_id = bucket.user_id
      - SELECT * FROM user_settings WHERE user_setting_user_id = bucket.user_id
```

4. Add `POWERSYNC_URL` to your configuration

### n8n (AI Features)

Self-host n8n or use n8n Cloud:

```bash
# Docker self-hosting
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

Configure workflows for transaction parsing, report generation, and
receipt/OCR processing, then set `N8N_BASE_URL` in your environment.

### Firebase (Push Notifications)

1. Create Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Install Firebase CLI: `npm install -g firebase-tools`
3. Run: `./flutterfire-config.sh`

## 🐛 Troubleshooting

### Common Issues

**"Invalid API key" error**
- Verify `SUPABASE_ANON_KEY` is correct
- Check that Row Level Security is properly configured

**"Table not found" error**
- Run the database schema SQL in Supabase
- Verify tables were created in Table Editor

**"PowerSync connection failed"**
- Verify `POWERSYNC_URL` is correct
- Check that sync rules are properly configured

**Authentication not working**
- Enable providers in Supabase Authentication settings
- For Google Sign-In, verify OAuth credentials

## 💡 Tips

- Start with just Supabase - other services are optional
- Use Supabase free tier for development
- All data stays in your Supabase project
- You can export your data anytime via SQL

## 🤝 Getting Help

- [GitHub Discussions](https://github.com/quimblelabs/felicash-app/discussions) - Questions & community support
- [Issues](https://github.com/quimblelabs/felicash-app/issues) - Bug reports

---

**Happy self-hosting!** 🎉
