'use client';

import { useBlockNumber as useWagmiBlockNumber } from 'wagmi';

export function useBlockNumber() {
  const { data: blockNumber } = useWagmiBlockNumber({ watch: true });

  return {
    blockNumber: blockNumber ? Number(blockNumber) : 0,
  };
}
