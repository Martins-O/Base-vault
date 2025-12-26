interface BadgeProps {
  text: string;
  variant?: 'success' | 'warning' | 'error' | 'info';
}

export function Badge({ text, variant = 'info' }: BadgeProps) {
  const variants = {
    success: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200',
    warning: 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200',
    error: 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200',
    info: 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200',
  };

  return (
    <span className={`px-2 py-1 rounded-full text-xs font-semibold ${variants[variant]}`}>
      {text}
    </span>
  );
}
