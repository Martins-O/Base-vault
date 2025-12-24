'use client';

import { useEnsName } from 'wagmi';

export function useENS(address?: string) {
  const { data: ensName } = useEnsName({
    address: address as `0x${string}` | undefined,
  });

  return {
    ensName,
    displayName: ensName || address,
  };
}
