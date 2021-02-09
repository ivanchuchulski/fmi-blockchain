const HDWalletProvider = require("truffle-hdwallet-provider-privkey");
const privateKey =
  "827b8ecc715f5442465ff0c11cc963f08c6772091b3d8e06a71d23c1f4b9ceae";
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
