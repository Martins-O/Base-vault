interface APYBadgeProps {
  apy: number;
}

export function APYBadge({ apy }: APYBadgeProps) {
  const getColor = (value: number) => {
    if (value >= 15) return 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200';
    if (value >= 10) return 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200';
    return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200';
  };

  return (
    <span className={`px-3 py-1 rounded-full text-sm font-semibold ${getColor(apy)}`}>
      {apy.toFixed(2)}% APY
    </span>
  );
}
