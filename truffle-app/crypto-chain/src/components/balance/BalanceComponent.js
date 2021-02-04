import React from "react";
import { Web3ReactProvider } from "@web3-react/core";
import { Web3Provider } from "@ethersproject/providers";
import { useWeb3React } from "@web3-react/core";
import { InjectedConnector } from "@web3-react/injected-connector";
import useSWR from "swr";

export const injectedConnector = new InjectedConnector({
  supportedChainIds: [
    1, // Mainet
    3, // Ropsten
    4, // Rinkeby
    5, // Goerli
    42, // Kovan
  ],
});

function getLibrary(provider) {
  const library = new Web3Provider(provider);
  library.pollingInterval = 12000;
  return library;
}

export const Wallet = () => {
  const { chainId, account, activate, active } = useWeb3React();

  const onClick = () => {
    activate(injectedConnector);
  };

  return (
    <div>
      <div>ChainId: {chainId}</div>
      <div>Account: {account}</div>
      {active ? (
        <div>✅ </div>
      ) : (
        <button type="button" onClick={onClick}>
          Connect
        </button>
      )}
    </div>
  );
};

const fetcher = (library) => (...args) => {
  const [method, ...params] = args;
  console.log(method, params);
  return library[method](...params);
};

export const Balance = () => {
  const { account, library } = useWeb3React();
  const { data: balance } = useSWR(["getBalance", account, "latest"], {
    fetcher: fetcher(library),
  });
  if (!balance) {
    return <div>...</div>;
  }
  return <div>Balance: {balance.toString()}</div>;
};

export const App = () => {
  return (
    <Web3ReactProvider getLibrary={getLibrary}>
      <Wallet />
      <Balance></Balance>
    </Web3ReactProvider>
  );
};

export default App;
