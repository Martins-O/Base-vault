'use client';

import { ConnectButton } from '@/components/ConnectButton';
import { VaultCard } from '@/components/VaultCard';
import { CONTRACTS } from '@/lib/contracts';

export default function Vaults() {
  const vaults = [
    {
      name: 'Interactive USDC Vault',
      address: CONTRACTS.INTERACTIVE_VAULT,
      tvl: '$25,432',
      apy: '12.5%',
      strategy: 'Multi-Strategy',
    },
    {
      name: 'Aerodrome Strategy Vault',
      address: CONTRACTS.AERODROME_STRATEGY,
      tvl: '$18,250',
      apy: '15.2%',
      strategy: 'Aerodrome LP',
    },
    {
      name: 'Uniswap V3 Strategy Vault',
      address: CONTRACTS.UNISWAP_V3_STRATEGY,
      tvl: '$31,890',
      apy: '10.8%',
      strategy: 'Uniswap V3',
    },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800">
      <nav className="bg-white dark:bg-gray-800 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <h1 className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">
              Explore Vaults
            </h1>
            <ConnectButton />
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h2 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">
            All Vaults
          </h2>
          <p className="text-gray-600 dark:text-gray-400">
            Choose from our optimized yield strategies on Base network
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {vaults.map((vault) => (
            <VaultCard key={vault.address} {...vault} />
          ))}
        </div>

        <div className="mt-12 bg-white dark:bg-gray-800 rounded-lg shadow-md p-8">
          <h3 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            How It Works
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div>
              <div className="text-3xl font-bold text-indigo-600 dark:text-indigo-400 mb-2">
                1
              </div>
              <h4 className="font-semibold text-gray-900 dark:text-white mb-2">
                Deposit Assets
              </h4>
              <p className="text-gray-600 dark:text-gray-400">
                Connect your wallet and deposit USDC into your chosen vault
              </p>
            </div>
            <div>
              <div className="text-3xl font-bold text-indigo-600 dark:text-indigo-400 mb-2">
                2
              </div>
              <h4 className="font-semibold text-gray-900 dark:text-white mb-2">
                Earn Yield
              </h4>
              <p className="text-gray-600 dark:text-gray-400">
                Your assets automatically earn yield through optimized DeFi strategies
              </p>
            </div>
            <div>
              <div className="text-3xl font-bold text-indigo-600 dark:text-indigo-400 mb-2">
                3
              </div>
              <h4 className="font-semibold text-gray-900 dark:text-white mb-2">
                Withdraw Anytime
              </h4>
              <p className="text-gray-600 dark:text-gray-400">
                Withdraw your principal plus earnings at any time
              </p>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
