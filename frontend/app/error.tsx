'use client';

import { useEffect } from 'react';

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error(error);
  }, [error]);

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800">
      <div className="text-center">
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
          Something went wrong!
        </h2>
        <button
          onClick={reset}
          className="px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md transition-colors"
        >
          Try again
        </button>
      </div>
    </div>
  );
}
