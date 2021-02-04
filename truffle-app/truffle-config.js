const HDWalletProvider = require("truffle-hdwallet-provider-privkey");
const privateKey =
  "87d5db9d8d0afeff10cec3c7c3c4f40bc49b344efa810b8d7f2a3d6006e7b0b9";
const endpointUrl =
  "https://kovan.infura.io/v3/d247337838e843ac82468d8ad84c7bb4";

module.exports = {
  compilers: {
    solc: {
      version: "0.6.8",
    },
  },
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "5777",
    },
    kovan: {
      provider: function () {
        return new HDWalletProvider(
          //private keys array
          [privateKey],
          //url to ethereum node
          endpointUrl
        );
      },
      gas: 5000000,
      gasPrice: 25000000000,
      network_id: 42,
    },
  },
};
