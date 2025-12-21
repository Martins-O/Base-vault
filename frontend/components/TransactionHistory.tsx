'use client';

interface Transaction {
  hash: string;
  type: 'deposit' | 'withdraw';
  amount: string;
  timestamp: string;
  status: 'success' | 'pending' | 'failed';
}

export function TransactionHistory({ transactions }: { transactions: Transaction[] }) {
  return (
    <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
      <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
        Recent Transactions
      </h3>

      {transactions.length === 0 ? (
        <p className="text-gray-500 dark:text-gray-400 text-center py-8">
          No transactions yet
        </p>
      ) : (
        <div className="space-y-3">
          {transactions.map((tx) => (
            <div
              key={tx.hash}
              className="flex items-center justify-between p-3 bg-gray-50 dark:bg-gray-700 rounded-md"
            >
              <div className="flex-1">
                <div className="flex items-center gap-2">
                  <span
                    className={`px-2 py-1 text-xs rounded-full ${
                      tx.type === 'deposit'
                        ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200'
                        : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200'
                    }`}
                  >
                    {tx.type}
                  </span>
                  <span className="text-sm text-gray-600 dark:text-gray-400">
                    {tx.amount} USDC
                  </span>
                </div>
                <p className="text-xs text-gray-500 dark:text-gray-400 mt-1 font-mono">
                  {tx.hash.slice(0, 10)}...{tx.hash.slice(-8)}
                </p>
              </div>
              <div className="text-right">
                <span
                  className={`text-xs px-2 py-1 rounded ${
                    tx.status === 'success'
                      ? 'bg-green-100 text-green-800'
                      : tx.status === 'pending'
                      ? 'bg-yellow-100 text-yellow-800'
                      : 'bg-red-100 text-red-800'
                  }`}
                >
                  {tx.status}
                </span>
                <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  {tx.timestamp}
                </p>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
