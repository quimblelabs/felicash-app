# FeliCash API Documentation

This document describes the data schema and service integrations used by
FeliCash.

## 📑 Table of Contents

- [Overview](#overview)
- [Runtime Configuration](#runtime-configuration)
- [Supabase Backend Schema](#supabase-backend-schema)
- [PowerSync App Client Schema](#powersync-app-client-schema)
- [Schema Alignment Notes](#schema-alignment-notes)
- [n8n AI Workflows](#n8n-ai-workflows)
- [Authentication](#authentication)

## 🎯 Overview

FeliCash uses the following services:

- **Supabase**: Primary PostgreSQL database and authentication
- **PowerSync**: Offline-first sync for app local database
- **n8n**: AI workflow orchestration
- **FreeCurrencyAPI**: Exchange-rate data provider

## ⚙️ Runtime Configuration

Based on `lib/main/bootstrap.dart` and the flavor entrypoints under `lib/main/`,
the app reads these `--dart-define` keys:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `FELICASH_LOCAL_DB_NAME`
- `POWERSYNC_URL`
- `N8N_BASE_URL`
- `ELEVENLABS_BASE_URL`
- `ELEVENLABS_API_KEY`
- `OPENAI_BASE_URL`
- `OPENAI_API_KEY`

For Google sign-in, the app also expects platform IDs in configuration:

- `IOS_CLIENT_ID`
- `WEB_CLIENT_ID`

## 🗄️ Supabase Backend Schema

The following schema reflects the current exported Supabase structure.

### Core finance tables

| Table | Primary Key | Purpose |
|---|---|---|
| `profiles` | `profile_id` | User profile and FCM token |
| `wallets` | `wallet_id` | Base wallet records |
| `credit_wallets` | `credit_wallet_id` | Credit-specific wallet extension |
| `savings_wallets` | `savings_wallet_id` | Savings-specific wallet extension |
| `categories` | `category_id` | Income/expense categories |
| `transactions` | `transaction_id` | Transaction ledger |
| `recurrences` | `recurrence_id` | Recurrence metadata |
| `lending_borrowing_transactions` | `lending_borrowing_transaction_id` | Lending/borrowing extension |
| `payback_links` | `payback_link_id` | Links payback tx to original tx |
| `merchants` | `merchant_id` | Merchant metadata |
| `exchange_rates` | `exchange_rate_id` | FX rates |
| `budgets` | `budget_id` | Budget definitions |
| `budget_trackings` | `budget_tracking_id` | Budget consumption tracking |
| `user_settings` | `user_setting_id` | User preferences |

### AI tables

| Table | Primary Key | Purpose |
|---|---|---|
| `ai_query_type` | `ai_query_type_code` | AI query type dictionary |
| `ai_queries` | `ai_query_id` | AI user queries and responses |
| `ai_logs` | `ai_log_id` | Execution logs and feedback |
| `ai_transaction_documents` | `id` | AI document vectors/metadata |

### Enum-backed columns (USER-DEFINED)

- `budgets.budget_budget_period`
- `categories.category_transaction_type`
- `recurrences.recurrence_recurrence_type`
- `transactions.transaction_transaction_type`
- `wallets.wallet_wallet_type`

### Relationship highlights

- `transactions.transaction_wallet_id -> wallets.wallet_id`
- `transactions.transaction_category_id -> categories.category_id`
- `transactions.transaction_recurrence_id -> recurrences.recurrence_id`
- `transactions.transaction_merchant_id -> merchants.merchant_id`
- `credit_wallets.credit_wallet_wallet_id -> wallets.wallet_id`
- `savings_wallets.savings_wallet_wallet_id -> wallets.wallet_id`
- `budgets.budget_category_id -> categories.category_id`
- `budget_trackings.budget_tracking_transaction_id -> transactions.transaction_id`

## 📱 PowerSync App Client Schema

The app local schema is defined in
`packages/clients/felicash_data_client/lib/src/models/schema.dart`.

### Local synced tables

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

### Tables that remain backend-only

- `ai_query_type`
- `ai_queries`
- `ai_logs`
- `ai_transaction_documents`

### Local typing notes

- Boolean-like fields are represented as integers in local schema:
  - `category_enabled`
  - `wallet_exclude_from_total`
  - `wallet_archived`
- Date/time fields are stored as text in local schema and parsed at model layer.

## 🔄 Schema Alignment Notes

1. The app follows a prefixed column naming style consistently across backend
   and client schemas (for example, `transaction_amount`, `wallet_name`).
2. Backend and PowerSync table coverage is aligned for finance-domain data.
3. `user_settings` has a backend column named `user_setting_default_walllet`
   (triple "l") in the exported SQL; the client schema uses
   `user_setting_default_wallet`. Keep this mapping explicit in sync/select
   logic to avoid mismatches.

## 🤖 n8n AI Workflows

The app integrates with n8n via `N8N_BASE_URL` for:

- Transaction parsing from natural-language text
- AI report generation
- Receipt/OCR-related AI processing

Workflow route paths are deployment-specific and managed in your n8n instance.

## 🔐 Authentication

FeliCash uses Supabase Auth with:

- Email/Password
- Google OAuth
- Apple OAuth

Token management in app bootstrapping uses the `token_storage` package with
`InMemoryTokenStorage` in current flavor entrypoints.

---

For backend API and policy details, see [Supabase Docs](https://supabase.com/docs).
