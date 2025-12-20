'use client';

import { ConnectButton as RainbowConnectButton } from '@rainbow-me/rainbowkit';

export function ConnectButton() {
  return (
    <RainbowConnectButton
      showBalance={{
        smallScreen: false,
        largeScreen: true,
      }}
      chainStatus="icon"
    />
  );
}
