# BaseVault Frontend

Interactive frontend for BaseVault DeFi yield optimization platform on Base network.

## Features

- Connect wallet via RainbowKit
- Deposit/withdraw from vaults
- View vault statistics
- Track user positions
- Real-time APY updates

## Tech Stack

- Next.js 14 (App Router)
- TypeScript
- TailwindCSS
- wagmi v2
- viem
- RainbowKit
- TanStack Query

## Getting Started

1. Install dependencies:
```bash
npm install
```

2. Create `.env.local` file:
```bash
cp .env.example .env.local
```

3. Add your WalletConnect Project ID to `.env.local`

4. Run development server:
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Contract Addresses (Base Sepolia)

- FeeCollector: `0xCd5De20043a8aE46D80a22678b0Eb8B1078829Ce`
- InteractiveVault: `0x24ed030F7F62E05Eb5842bF5197c87a82397BDAC`
- VaultFactory: `0xd4b5C23ACB221AC6F8671EC3d45141E346ee80d8`

## Build

```bash
npm run build
```

## Deploy

```bash
npm run start
```
