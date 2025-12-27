export function isValidAddress(address: string): boolean {
  return /^0x[a-fA-F0-9]{40}$/.test(address);
}

export function isValidAmount(amount: string): boolean {
  const num = parseFloat(amount);
  return !isNaN(num) && num > 0;
}

export function validateDepositAmount(amount: string, balance: number): {
  isValid: boolean;
  error?: string;
} {
  if (!isValidAmount(amount)) {
    return { isValid: false, error: 'Invalid amount' };
  }

  const num = parseFloat(amount);
  if (num > balance) {
    return { isValid: false, error: 'Insufficient balance' };
  }

  return { isValid: true };
}
