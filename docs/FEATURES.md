# FeliCash Features

This document provides detailed information about FeliCash features and functionality.

## 📑 Table of Contents

- [Implementation Status](#implementation-status)
- [User Roles](#user-roles)
- [Authentication](#authentication)
- [User Profile Management](#user-profile-management)
- [Transaction Management](#transaction-management)
- [Wallet Management](#wallet-management)
- [Budget Planning](#budget-planning)
- [Reports & Analytics](#reports--analytics)
- [AI Assistant](#ai-assistant)

## 📊 Implementation Status

| Feature | Status | Notes |
|---------|--------|-------|
| Email/Password Authentication | ✅ Implemented | Login with email/password |
| Google Sign-In | ✅ Implemented | OAuth via Google |
| Apple Sign-In | ✅ Implemented | OAuth via Apple (iOS only) |
| Wallet Management | ✅ Implemented | Create, edit, delete wallets |
| Transaction CRUD | ✅ Implemented | Create, read, update, delete transactions |
| Transaction Categories | ✅ Implemented | Category management with icons/colors |
| Voice Transaction Input | ✅ Implemented | Speech-to-text transaction creation |
| AI Transaction Parsing | ✅ Implemented | n8n-based text extraction |
| Multi-Currency Support | ✅ Implemented | 150+ currencies with exchange rates |
| Spending by Category | ✅ Implemented | Pie chart visualization |
| Monthly Trending | ✅ Implemented | Income/expense charts |
| AI Assistant Chat | ✅ Implemented | Natural language queries |
| Text-to-Speech | ✅ Implemented | AI response playback |
| Transaction Filtering | ✅ Implemented | Date, category, wallet, type filters |
| Recurring Transactions | 📝 Partial | Backend/domain support exists |
| Scheduled Transactions | 📝 Partial | Backend/domain support exists |
| Budget Planning | 📋 Planned | Not yet implemented |
| PDF Export | 📋 Planned | Not yet implemented |
| Lending/Borrowing Types | 📝 Partial | Type exists in schema, limited UI |
| Pro User Tier | 📋 Planned | Not yet implemented |

**Legend:**
- ✅ Implemented - Feature is available in the app UI
- 📝 Partial - Backend/domain support exists but UI may be limited
- 📋 Planned - Feature is planned but not yet implemented

## 👤 User Roles

### Guest
- Limited access to app features
- Can view demo data
- Cannot create or modify transactions

### User
- Full access to standard features
- Can create and manage transactions
- Can set up wallets and categories
- Access to basic reports

### Pro User

> **📋 Planned:** Pro User tier is planned but not yet implemented. The following features are anticipated:
> - Premium AI features
> - Advanced analytics
> - Unlimited transaction history
> - Priority support

## 🔐 Authentication

### Supported Methods
- **Email/Password** - Traditional login
- **Google Sign-In** - OAuth via Google
- **Apple Sign-In** - OAuth via Apple (iOS only)

### Security Features
- Token storage (configurable: in-memory for development)
- Automatic token refresh
- Session management
- Secure logout

## 👤 User Profile Management

Users can update their profile details:

| Field | Description | Status |
|-------|-------------|--------|
| Profile Picture | User avatar | ✅ Implemented |
| Username | Display name | ✅ Implemented |
| Date of Birth | For age verification | 📋 Planned |
| Gender | User preference | 📋 Planned |
| Address | Location information | 📋 Planned |
| Phone Number | Contact number | 📋 Planned |
| Email | Primary contact | ✅ Implemented |

## 💰 Transaction Management

### Manual Transaction Entry

Create transactions with:
- **Note** - Transaction description
- **Image Attachment** - Receipt or photo
- **Timestamp** - Transaction date/time
- **Transaction Type** - Income, Expense, Transfer
- **Location** - GPS coordinates (optional)
- **Wallet Selection** - Source/destination wallet

### Transaction Types

| Type | Description | Status |
|------|-------------|--------|
| Income | Salary, gifts, bonuses, etc. | ✅ Implemented |
| Expense | General spending | ✅ Implemented |
| Transfer | Between own wallets | ✅ Implemented |
| Lending | Money lent to others | 📝 Partial (schema support) |
| Borrowing | Money borrowed | 📝 Partial (schema support) |

### Recurring Transactions

> **📝 Partial Implementation:** Recurring transaction support exists in the backend/domain models but the full UI for managing recurring schedules is not yet complete.

Supported frequencies (when fully implemented):
- **Daily** - Every day
- **Weekly** - Every week
- **Bi-weekly** - Every two weeks
- **Monthly** - Every month
- **Yearly** - Every year
- **Custom** - Custom interval

### Scheduled Transactions

> **📝 Partial Implementation:** Scheduled transaction support exists in the backend/domain models but the UI for scheduling future transactions is not yet complete.

Features planned:
- Schedule future transactions
- Set reminders
- Automatic execution

### Voice Transaction

Create transactions using voice:
1. Tap microphone button
2. Speak transaction details
3. AI extracts information
4. Review and confirm

Example: *"I spent $50 on groceries at Walmart yesterday"*

### Receipt Scanning (OCR)

> **📋 Planned:** OCR-powered receipt scanning is planned but not yet fully implemented.

Planned flow:
1. Take photo of receipt
2. OCR extracts details
3. Review extracted data
4. Save transaction

### Multi-Currency Support

- **150+ Currencies** supported
- **Real-time exchange rates** via FreeCurrencyAPI
- **Automatic conversion** between currencies
- **Exchange fee tracking** (optional)
- **Transfer between currencies** with rate logging

## 💳 Wallet Management

### Wallet Types

#### 1. Bank Wallet
- Digital bank account representation
- Track deposits and withdrawals
- Store bank details
- Monitor balance

#### 2. Cash Wallet
- Physical cash tracking
- Manual entry required
- On-hand cash flow monitoring

#### 3. Credit Card Wallet
- Credit card spending tracking
- Credit limit monitoring
- Interest rate tracking
- Due date reminders
- Outstanding balance

#### 4. Savings Wallet
- Dedicated savings accounts
- Financial goal setting
- Progress tracking
- Contribution monitoring

### Wallet Features

- **Icon Selection** - Custom wallet icons
- **Color Coding** - Visual organization
- **Currency Assignment** - Per-wallet currency
- **Exclude from Total** - Hide from overview
- **Credit Limit** (Credit wallets)
- **Savings Goal** (Savings wallets)

## 📊 Budget Planning

> **📋 Planned:** Budget planning features are not yet implemented.

Planned features:
- Set spending limits per category
- Track expenses against budgets
- Budget alerts and notifications
- Monthly/weekly budget periods

## 📈 Reports & Analytics

### Chart Statistics

#### Spending by Category
- Pie chart visualization
- Percentage breakdown
- Category filtering
- Date range selection

#### Monthly Trending
- Line/bar charts
- Income vs Expense comparison
- Transfer tracking
- Custom date ranges

### Smart Report

AI-powered natural language queries:

**Example Queries:**
- "How much did I spend on food last month?"
- "Show me my top 5 expenses this week"
- "Compare my spending to last month"
- "What categories increased the most?"

**Report Features:**
- Natural language input
- Voice query support
- AI-generated summaries
- Export to PDF (📋 Planned)

## 🤖 AI Assistant

### Features

- **Chat Interface** - Conversational interaction
- **Voice Commands** - Hands-free operation
- **Transaction Creation** - AI-powered parsing
- **Smart Reports** - Natural language queries
- **Text-to-Speech** - Listen to responses

### Supported Languages
- English
- Vietnamese

### Privacy
- Voice data processed locally where possible
- No voice data stored permanently
- User control over AI features

---

For feature requests, please open a [Feature Request](https://github.com/quimblelabs/felicash-app/issues/new?template=feature_request.md).
