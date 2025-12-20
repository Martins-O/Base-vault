'use client';

import { useState } from 'react';
import { useAccount, useWriteContract, useWaitForTransactionReceipt } from 'wagmi';
import { parseUnits } from 'viem';
import { CONTRACTS, INTERACTIVE_VAULT_ABI, ERC20_ABI } from '@/lib/contracts';

export function DepositForm() {
  const [amount, setAmount] = useState('');
  const [isApproving, setIsApproving] = useState(false);
  const { address } = useAccount();
  const { writeContract, data: hash } = useWriteContract();
  const { isLoading: isConfirming } = useWaitForTransactionReceipt({ hash });

  const handleApprove = async () => {
    if (!amount || !address) return;

    setIsApproving(true);
    try {
      const amountInWei = parseUnits(amount, 6); // USDC has 6 decimals

      writeContract({
        address: CONTRACTS.USDC,
        abi: ERC20_ABI,
        functionName: 'approve',
        args: [CONTRACTS.INTERACTIVE_VAULT, amountInWei],
      });
    } catch (error) {
      console.error('Approval error:', error);
    } finally {
      setIsApproving(false);
    }
  };

  const handleDeposit = async () => {
    if (!amount || !address) return;

    try {
      const amountInWei = parseUnits(amount, 6);

      writeContract({
        address: CONTRACTS.INTERACTIVE_VAULT,
        abi: INTERACTIVE_VAULT_ABI,
        functionName: 'deposit',
        args: [amountInWei, address],
      });
    } catch (error) {
      console.error('Deposit error:', error);
    }
  };

  return (
    <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
      <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
        Deposit USDC
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
        Fee: 0.5% ({amount ? (parseFloat(amount) * 0.005).toFixed(2) : '0.00'} USDC)
      </p>

      <div className="flex gap-3">
        <button
          onClick={handleApprove}
          disabled={!amount || isApproving || isConfirming || !address}
          className="flex-1 px-4 py-2 bg-gray-600 hover:bg-gray-700 disabled:bg-gray-400 text-white rounded-md transition-colors"
        >
          {isApproving ? 'Approving...' : 'Approve'}
        </button>
        <button
          onClick={handleDeposit}
          disabled={!amount || isConfirming || !address}
          className="flex-1 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 disabled:bg-indigo-400 text-white rounded-md transition-colors"
        >
          {isConfirming ? 'Depositing...' : 'Deposit'}
        </button>
      </div>

      {hash && (
        <p className="mt-4 text-sm text-green-600 dark:text-green-400">
          Transaction submitted: {hash.slice(0, 10)}...
        </p>
      )}
    </div>
  );
}
