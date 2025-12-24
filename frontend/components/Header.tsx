'use client';

import Link from 'next/link';
import { ConnectButton } from './ConnectButton';
import { NetworkStatus } from './NetworkStatus';

export function Header() {
  return (
    <header className="bg-white dark:bg-gray-800 shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16 items-center">
          <Link href="/" className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">
            BaseVault
          </Link>

          <nav className="hidden md:flex space-x-8">
            <Link href="/dashboard" className="text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400">
              Dashboard
            </Link>
            <Link href="/vaults" className="text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400">
              Vaults
            </Link>
            <Link href="/analytics" className="text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400">
              Analytics
            </Link>
          </nav>

          <div className="flex items-center gap-4">
            <NetworkStatus />
            <ConnectButton />
          </div>
        </div>
      </div>
    </header>
  );
}
