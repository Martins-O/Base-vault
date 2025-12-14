module.exports = {
  enabled: true,
  currency: 'USD',
  gasPrice: 20,
  coinmarketcap: process.env.COINMARKETCAP_API_KEY,
  token: 'ETH',
  onlyCalledMethods: true,
  excludeContracts: ['Mock', 'Test'],
  src: './src',
};
