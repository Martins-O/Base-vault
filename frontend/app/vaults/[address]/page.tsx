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
