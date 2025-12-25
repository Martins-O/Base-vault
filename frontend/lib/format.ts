export const formatters = {
  usd: (value: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(value);
  },

  number: (value: number) => {
    return new Intl.NumberFormat('en-US').format(value);
  },

  compact: (value: number) => {
    return new Intl.NumberFormat('en-US', {
      notation: 'compact',
      compactDisplay: 'short',
    }).format(value);
  },

  percentage: (value: number) => {
    return `${value.toFixed(2)}%`;
  },
};
