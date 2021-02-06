import { Web3ReactProvider } from "@web3-react/core";
import { Web3Provider } from "@ethersproject/providers";
import { useWeb3React } from "@web3-react/core";
import { InjectedConnector } from "@web3-react/injected-connector";
import useSWR from "swr";

import React, { useState } from "react";
import Web3 from "web3";
import { deployedAbi } from "../configurations/cryptoAbiConnection";
import web3 from "../configurations/web3";

export const causeService = {
  addCause,
  donateToCause,
  updateCause,
  stopFundraising,
  retrieveCauseInformation,
  retrieveCauses,
};

function addCause(cause) {
  var contractInstance = new web3.eth.Contract(
    deployedAbi,
    "0xfE277e47C16e0939932331bE3F731AAf81c1dF9e"
  );

  contractInstance.methods.addCause().call();
}

function donateToCause(cause) {}

function updateCause(cause) {}

function stopFundraising(carId) {}

function retrieveCauseInformation(id) {}

function retrieveCauses() {
  var contractInstance = new web3.eth.Contract(
    deployedAbi,
    "0xb550C57e46d1953BAc087aCAfCF8E0610C1f70Cd"
  );

  // call constant function (synchronous way)
  let causes = contractInstance.causes.call();

  contractInstance.methods.addCause.call();

  console.log(contractInstance.causes);
}

export default causeService;
