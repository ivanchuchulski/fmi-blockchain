import { Web3ReactProvider } from "@web3-react/core";
import { Web3Provider } from "@ethersproject/providers";
import { useWeb3React } from "@web3-react/core";
import { InjectedConnector } from "@web3-react/injected-connector";
import useSWR from "swr";

export const causeService = {
  addCause,
  donateToCause,
  updateCause,
  stopFundraising,
  retrieveCauseInformation,
  retrieveCauses,
};

function addCause(cause) {}

function donateToCause(cause) {}

function updateCause(cause) {}

function stopFundraising(carId) {}

function retrieveCauseInformation(id) {}

function retrieveCauses() {}

export default causeService;
