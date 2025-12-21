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
