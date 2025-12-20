'use client';

import { useState } from 'react';
import { useAccount, useWriteContract, useWaitForTransactionReceipt } from 'wagmi';
import { parseUnits } from 'viem';
import { CONTRACTS, INTERACTIVE_VAULT_ABI } from '@/lib/contracts';

export function WithdrawForm() {
  const [amount, setAmount] = useState('');
  const { address } = useAccount();
  const { writeContract, data: hash } = useWriteContract();
  const { isLoading: isConfirming } = useWaitForTransactionReceipt({ hash });

  const handleWithdraw = async () => {
    if (!amount || !address) return;

    try {
      const amountInWei = parseUnits(amount, 6);

      writeContract({
        address: CONTRACTS.INTERACTIVE_VAULT,
        abi: INTERACTIVE_VAULT_ABI,
        functionName: 'withdraw',
        args: [amountInWei, address, address],
      });
    } catch (error) {
      console.error('Withdraw error:', error);
    }
  };

  return (
    <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
      <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
        Withdraw USDC
      </h3>

      <div className="mb-4">
        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          Amount (USDC)
        </label>
        <input
          type="number"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          placeholder="0.00"
          className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
        />
      </div>

      <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">
        Fee: 0.3% ({amount ? (parseFloat(amount) * 0.003).toFixed(2) : '0.00'} USDC)
      </p>

      <button
        onClick={handleWithdraw}
        disabled={!amount || isConfirming || !address}
        className="w-full px-4 py-2 bg-indigo-600 hover:bg-indigo-700 disabled:bg-indigo-400 text-white rounded-md transition-colors"
      >
        {isConfirming ? 'Withdrawing...' : 'Withdraw'}
      </button>

      {hash && (
        <p className="mt-4 text-sm text-green-600 dark:text-green-400">
          Transaction submitted: {hash.slice(0, 10)}...
        </p>
      )}
    </div>
  );
}
