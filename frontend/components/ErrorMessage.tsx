interface ErrorMessageProps {
  title?: string;
  message: string;
  onRetry?: () => void;
}

export function ErrorMessage({ title = 'Error', message, onRetry }: ErrorMessageProps) {
  return (
    <div className="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4">
      <h4 className="text-red-800 dark:text-red-200 font-semibold mb-1">{title}</h4>
      <p className="text-red-600 dark:text-red-300 text-sm mb-3">{message}</p>
      {onRetry && (
        <button
          onClick={onRetry}
          className="text-sm text-red-700 dark:text-red-300 underline hover:no-underline"
        >
          Try again
        </button>
      )}
    </div>
  );
}
