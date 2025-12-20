interface StatsCardProps {
  title: string;
  value: string;
  change?: string;
  icon?: React.ReactNode;
}

export function StatsCard({ title, value, change, icon }: StatsCardProps) {
  return (
    <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
      <div className="flex items-center justify-between mb-2">
        <h3 className="text-sm font-medium text-gray-600 dark:text-gray-400">
          {title}
        </h3>
        {icon && <div className="text-indigo-600 dark:text-indigo-400">{icon}</div>}
      </div>
      <p className="text-2xl font-bold text-gray-900 dark:text-white">{value}</p>
      {change && (
        <p className={`text-sm mt-1 ${
          change.startsWith('+')
            ? 'text-green-600 dark:text-green-400'
            : 'text-red-600 dark:text-red-400'
        }`}>
          {change}
        </p>
      )}
    </div>
  );
}
