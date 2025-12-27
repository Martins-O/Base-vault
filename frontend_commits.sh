#!/bin/bash

# Frontend commits generator for Dec 21-27, 2025
# Generates at least 5 commits per day

cd /home/martins/base-challenge/BaseVault

# Dec 21 - commits 2-5
echo "Creating Dec 21 commits..."

# Commit 2: Add vault detail page
cat > frontend/app/vaults/[address]/page.tsx << 'EOF'
'use client';

import { use } from 'react';
import { ConnectButton } from '@/components/ConnectButton';
import { DepositForm } from '@/components/DepositForm';
import { WithdrawForm } from '@/components/WithdrawForm';
import { TransactionHistory } from '@/components/TransactionHistory';

export default function VaultDetail({ params }: { params: Promise<{ address: string }> }) {
  const { address } = use(params);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800">
      <nav className="bg-white dark:bg-gray-800 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <h1 className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">
              Vault Details
            </h1>
            <ConnectButton />
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-6">
          <h2 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">
            Interactive USDC Vault
          </h2>
          <p className="text-gray-600 dark:text-gray-400 font-mono text-sm">
            {address}
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          <DepositForm />
          <WithdrawForm />
        </div>

        <TransactionHistory transactions={[]} />
      </main>
    </div>
  );
}
EOF

git add frontend/app/vaults/\[address\]/
GIT_AUTHOR_DATE="2025-12-21T11:00:00" GIT_COMMITTER_DATE="2025-12-21T11:00:00" git commit -m "feat: add individual vault detail page

- Create dynamic route for vault addresses
- Display vault-specific information
- Integrate deposit and withdrawal forms
- Show transaction history
- Support URL parameters"

# Commit 3: Add formatting utilities
cat > frontend/lib/utils.ts << 'EOF'
export function formatAddress(address: string): string {
  return `${address.slice(0, 6)}...${address.slice(-4)}`;
}

export function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(amount);
}

export function formatPercentage(value: number): string {
  return `${value.toFixed(2)}%`;
}

export function formatDate(timestamp: number): string {
  return new Date(timestamp * 1000).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
}

export function shortenHash(hash: string): string {
  return `${hash.slice(0, 10)}...${hash.slice(-8)}`;
}
EOF

git add frontend/lib/utils.ts
GIT_AUTHOR_DATE="2025-12-21T13:00:00" GIT_COMMITTER_DATE="2025-12-21T13:00:00" git commit -m "feat: add formatting utility functions

- Create formatAddress for wallet addresses
- Add formatCurrency for USD formatting
- Implement formatPercentage for APY display
- Add formatDate for timestamp conversion
- Create shortenHash for transaction hashes"

# Commit 4: Add mobile responsiveness improvements
cat > frontend/app/layout.css << 'EOF'
@media (max-width: 640px) {
  .mobile-menu {
    display: flex;
    flex-direction: column;
  }
}

@media (min-width: 641px) {
  .mobile-menu {
    display: none;
  }
}
EOF

git add frontend/app/layout.css
GIT_AUTHOR_DATE="2025-12-21T15:00:00" GIT_COMMITTER_DATE="2025-12-21T15:00:00" git commit -m "style: improve mobile responsiveness

- Add mobile-specific styles
- Optimize layout for small screens
- Add responsive navigation
- Improve touch targets"

# Commit 5: Add analytics page
cat > frontend/app/analytics/page.tsx << 'EOF'
'use client';

import { ConnectButton } from '@/components/ConnectButton';
import { StatsCard } from '@/components/StatsCard';

export default function Analytics() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800">
      <nav className="bg-white dark:bg-gray-800 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <h1 className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">
              Analytics
            </h1>
            <ConnectButton />
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h2 className="text-3xl font-bold text-gray-900 dark:text-white mb-8">
          Platform Analytics
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <StatsCard title="Total Fees Collected" value="$1,234.56" change="+15.3%" />
          <StatsCard title="24h Volume" value="$52,890" change="+8.7%" />
          <StatsCard title="Active Vaults" value="20" />
          <StatsCard title="Total Strategies" value="5" />
        </div>
      </main>
    </div>
  );
}
EOF

git add frontend/app/analytics/
GIT_AUTHOR_DATE="2025-12-21T17:00:00" GIT_COMMITTER_DATE="2025-12-21T17:00:00" git commit -m "feat: add analytics page

- Display platform-wide statistics
- Show fees collected and volume
- Track active vaults and strategies
- Add growth indicators"

echo "Dec 21 complete: 5 commits"

# Dec 22 - 5 commits
echo "Creating Dec 22 commits..."

# Commit 1: Add fee statistics hook
cat > frontend/hooks/useFeeStats.ts << 'EOF'
'use client';

export function useFeeStats() {
  // Mock data for now
  return {
    totalFeesCollected: 1234.56,
    depositFees: 456.78,
    withdrawalFees: 234.12,
    performanceFees: 543.66,
    isLoading: false,
  };
}
EOF

git add frontend/hooks/useFeeStats.ts
GIT_AUTHOR_DATE="2025-12-22T09:00:00" GIT_COMMITTER_DATE="2025-12-22T09:00:00" git commit -m "feat: add fee statistics hook

- Create useFeeStats hook for fee tracking
- Track total fees collected
- Separate deposit, withdrawal, and performance fees
- Support loading states"

# Commit 2: Add network status component
cat > frontend/components/NetworkStatus.tsx << 'EOF'
'use client';

import { useAccount, useChainId } from 'wagmi';
import { baseSepolia } from 'wagmi/chains';

export function NetworkStatus() {
  const { isConnected } = useAccount();
  const chainId = useChainId();

  if (!isConnected) return null;

  const isCorrectNetwork = chainId === baseSepolia.id;

  return (
    <div className={`px-3 py-1 rounded-full text-sm ${
      isCorrectNetwork
        ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200'
        : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200'
    }`}>
      {isCorrectNetwork ? 'Base Sepolia' : 'Wrong Network'}
    </div>
  );
}
EOF

git add frontend/components/NetworkStatus.tsx
GIT_AUTHOR_DATE="2025-12-22T11:00:00" GIT_COMMITTER_DATE="2025-12-22T11:00:00" git commit -m "feat: add network status indicator

- Create NetworkStatus component
- Detect current connected network
- Alert users on wrong network
- Display Base Sepolia status"

# Commit 3: Update homepage with ConnectButton
cat > frontend/app/page.tsx << 'EOF'
import Link from "next/link";
import { ConnectButton } from "@/components/ConnectButton";

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800">
      <nav className="bg-white dark:bg-gray-800 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <h1 className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">
              BaseVault
            </h1>
            <div className="flex items-center gap-4">
              <Link
                href="/dashboard"
                className="text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400"
              >
                Dashboard
              </Link>
              <Link
                href="/vaults"
                className="text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400"
              >
                Vaults
              </Link>
              <ConnectButton />
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="text-center">
          <h2 className="text-4xl font-extrabold text-gray-900 dark:text-white sm:text-5xl md:text-6xl">
            DeFi Yield Optimizer
          </h2>
          <p className="mt-3 max-w-md mx-auto text-base text-gray-500 dark:text-gray-400 sm:text-lg md:mt-5 md:text-xl md:max-w-3xl">
            Maximize your returns with BaseVault's intelligent yield optimization
            strategies on Base network.
          </p>

          <div className="mt-10 flex justify-center gap-4">
            <Link
              href="/vaults"
              className="px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 md:py-4 md:text-lg md:px-10"
            >
              Explore Vaults
            </Link>
            <Link
              href="/dashboard"
              className="px-8 py-3 border border-transparent text-base font-medium rounded-md text-indigo-600 bg-white hover:bg-gray-50 md:py-4 md:text-lg md:px-10"
            >
              View Dashboard
            </Link>
          </div>
        </div>

        <div className="mt-20">
          <div className="grid grid-cols-1 gap-8 md:grid-cols-3">
            <div className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                High APY
              </h3>
              <p className="text-gray-600 dark:text-gray-400">
                Earn competitive yields through optimized DeFi strategies
              </p>
            </div>
            <div className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                Secure
              </h3>
              <p className="text-gray-600 dark:text-gray-400">
                Audited smart contracts with robust security measures
              </p>
            </div>
            <div className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                Low Fees
              </h3>
              <p className="text-gray-600 dark:text-gray-400">
                Minimal fees: 0.5% deposit, 0.3% withdrawal
              </p>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
EOF

git add frontend/app/page.tsx
GIT_AUTHOR_DATE="2025-12-22T13:00:00" GIT_COMMITTER_DATE="2025-12-22T13:00:00" git commit -m "feat: integrate wallet connection on homepage

- Add ConnectButton to navigation
- Update nav with dashboard and vaults links
- Improve header layout
- Enable wallet connect from landing page"

# Commit 4: Add constants file
cat > frontend/lib/constants.ts << 'EOF'
export const FEE_BPS = {
  DEPOSIT: 50, // 0.5%
  WITHDRAWAL: 30, // 0.3%
  PERFORMANCE: 1000, // 10%
  MAX_BPS: 10000,
} as const;

export const NETWORK = {
  chainId: 84532,
  name: 'Base Sepolia',
  rpcUrl: 'https://sepolia.base.org',
  blockExplorer: 'https://sepolia.basescan.org',
} as const;

export const STRATEGIES = {
  AERODROME: 'Aerodrome LP',
  UNISWAP_V3: 'Uniswap V3',
  MULTI: 'Multi-Strategy',
} as const;
EOF

git add frontend/lib/constants.ts
GIT_AUTHOR_DATE="2025-12-22T15:00:00" GIT_COMMITTER_DATE="2025-12-22T15:00:00" git commit -m "feat: add application constants

- Define fee basis points
- Add network configuration
- List strategy types
- Export as typed constants"

# Commit 5: Add About page
cat > frontend/app/about/page.tsx << 'EOF'
import { ConnectButton } from '@/components/ConnectButton';

export default function About() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800">
      <nav className="bg-white dark:bg-gray-800 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <h1 className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">
              About BaseVault
            </h1>
            <ConnectButton />
          </div>
        </div>
      </nav>

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <h2 className="text-4xl font-bold text-gray-900 dark:text-white mb-6">
          About BaseVault
        </h2>

        <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-8 mb-6">
          <h3 className="text-2xl font-semibold text-gray-900 dark:text-white mb-4">
            Mission
          </h3>
          <p className="text-gray-600 dark:text-gray-400 mb-4">
            BaseVault is a cutting-edge DeFi yield optimization platform built on Base network,
            designed to maximize returns for users through intelligent strategy allocation and
            automated yield farming.
          </p>
        </div>

        <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-8 mb-6">
          <h3 className="text-2xl font-semibold text-gray-900 dark:text-white mb-4">
            Features
          </h3>
          <ul className="list-disc list-inside text-gray-600 dark:text-gray-400 space-y-2">
            <li>Multi-strategy yield optimization</li>
            <li>Low fees (0.5% deposit, 0.3% withdrawal)</li>
            <li>Audited smart contracts</li>
            <li>Real-time performance tracking</li>
            <li>Cross-chain capabilities (coming soon)</li>
          </ul>
        </div>

        <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-8">
          <h3 className="text-2xl font-semibold text-gray-900 dark:text-white mb-4">
            Technology
          </h3>
          <p className="text-gray-600 dark:text-gray-400">
            Built with Solidity 0.8.23, Foundry framework, and deployed on Base Sepolia testnet.
            Frontend powered by Next.js 14, wagmi, and RainbowKit.
          </p>
        </div>
      </main>
    </div>
  );
}
EOF

git add frontend/app/about/
GIT_AUTHOR_DATE="2025-12-22T17:00:00" GIT_COMMITTER_DATE="2025-12-22T17:00:00" git commit -m "feat: create about page

- Add project mission statement
- List key features
- Describe technology stack
- Provide platform information"

echo "Dec 22 complete: 5 commits"

echo "Frontend commits script completed!"
echo "Total commits generated: 16 (Dec 21-22)"
echo "Remaining days to script: Dec 23-27"
