import BigNumber from 'bignumber.js';

export const isValidEthAddress = (ethAddress) => {
  return /^(0x){1}[0-9a-fA-F]{40}$/i.test(ethAddress);
};

export const ethToWei = (eth) => {
  return new BigNumber(eth).multipliedBy(new BigNumber(10).pow(18)).toString();
};

export const weiToEth = (wei) => {
  return new BigNumber(wei).dividedBy(new BigNumber(10).pow(18)).toString();
};
