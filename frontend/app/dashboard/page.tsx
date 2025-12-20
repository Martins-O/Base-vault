'use client';

import { ConnectButton } from '@/components/ConnectButton';
import { StatsCard } from '@/components/StatsCard';
import { DepositForm } from '@/components/DepositForm';
import { WithdrawForm } from '@/components/WithdrawForm';
import { useVaultData } from '@/hooks/useVaultData';
import { useUserPosition } from '@/hooks/useUserPosition';
import { useAccount } from 'wagmi';

export default function Dashboard() {
  const { isConnected } = useAccount();
  const { totalAssets, totalUsers } = useVaultData();
  const { totalDeposited, totalWithdrawn, feesPaid, shareBalance, usdcBalance } = useUserPosition();

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800">
      <nav className="bg-white dark:bg-gray-800 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <h1 className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">
              BaseVault Dashboard
            </h1>
            <ConnectButton />
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Global Stats */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <StatsCard
            title="Total Value Locked"
            value={`$${totalAssets.toLocaleString('en-US', { maximumFractionDigits: 2 })}`}
          />
          <StatsCard
            title="Total Users"
            value={totalUsers.toString()}
          />
          <StatsCard
            title="Average APY"
            value="12.5%"
            change="+2.3%"
          />
          <StatsCard
            title="Your Shares"
            value={shareBalance.toFixed(4)}
          />
        </div>

        {isConnected ? (
          <>
            {/* User Position */}
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 mb-8">
              <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-6">
                Your Position
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <div>
                  <p className="text-sm text-gray-600 dark:text-gray-400">Total Deposited</p>
                  <p className="text-xl font-semibold text-gray-900 dark:text-white">
                    ${totalDeposited.toFixed(2)}
                  </p>
                </div>
                <div>
                  <p className="text-sm text-gray-600 dark:text-gray-400">Total Withdrawn</p>
                  <p className="text-xl font-semibold text-gray-900 dark:text-white">
                    ${totalWithdrawn.toFixed(2)}
                  </p>
                </div>
                <div>
                  <p className="text-sm text-gray-600 dark:text-gray-400">Fees Paid</p>
                  <p className="text-xl font-semibold text-gray-900 dark:text-white">
                    ${feesPaid.toFixed(2)}
                  </p>
                </div>
                <div>
                  <p className="text-sm text-gray-600 dark:text-gray-400">USDC Balance</p>
                  <p className="text-xl font-semibold text-gray-900 dark:text-white">
                    ${usdcBalance.toFixed(2)}
                  </p>
                </div>
              </div>
            </div>

            {/* Deposit/Withdraw Forms */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <DepositForm />
              <WithdrawForm />
            </div>
          </>
        ) : (
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-12 text-center">
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
              Connect Your Wallet
            </h2>
            <p className="text-gray-600 dark:text-gray-400 mb-6">
              Connect your wallet to view your position and interact with vaults
            </p>
            <div className="flex justify-center">
              <ConnectButton />
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
