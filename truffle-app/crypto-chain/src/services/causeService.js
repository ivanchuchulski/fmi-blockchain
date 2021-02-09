function addCause(cause) {
  // var contractInstance = new web3.eth.Contract(
  //   deployedAbi,
  //   "0xfE277e47C16e0939932331bE3F731AAf81c1dF9e"
  // );

  // contractInstance.methods.addCause().call();
}

function donateToCause(cause) {}

function updateCause(cause) {}

function stopFundraising(carId) {}

function retrieveCauseInformation(id) {}

const retrieveCauses = async() => {
  if (window.ethereum) {
    window.ethereum.enable();
  }
  const res = await window.ethereum.request({ method: 'eth_requestAccounts' });
  console.log(res, window.ethereum.selectedAddress);
  // Window.ethereum.selectedAddress is the public address of the account connected to the metamask
  if(!window.ethereum.isConnected()){
    return;
  }
}

export const causeService = {
  addCause,
  donateToCause,
  updateCause,
  stopFundraising,
  retrieveCauseInformation,
  retrieveCauses,
};
export default causeService;
