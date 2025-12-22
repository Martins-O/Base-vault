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
