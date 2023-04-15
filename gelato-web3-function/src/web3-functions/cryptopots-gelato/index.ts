import {
  Web3Function,
  Web3FunctionContext,
} from "@gelatonetwork/web3-functions-sdk";
import { Contract } from "ethers";
import ky from "ky"; // we recommend using ky as axios doesn't support fetch by default

const CONTRACT_ABI = ["function mint(address to, uint256 value)"];

Web3Function.onRun(async (context: Web3FunctionContext) => {
  const { userArgs, storage, provider } = context;

  // Create contract
  const contractAddress =
    (userArgs.contract as string) ?? "0xDB56Da51945792F871B90065F1Bdaaa478D550ec";
  const contract = new Contract(contractAddress, CONTRACT_ABI, provider);

  let latestValue = 0;
  try {

    const meterDataApi = `https://sheets.googleapis.com/v4/spreadsheets/1qMjKKIKLaQzOGphTOEtHzdG9kipPFMcGd7g0Qf323Sg/values/Sheet1?key=AIzaSyCtsfgaw7L3jPmVxudqw4ble2riEgEPdn0`;

    const wattageData: {
      range: string;
      majorDimension: string;
      values: Array<Array<string>>;
    } = await ky
      .get(meterDataApi, { timeout: 5_000, retry: 0 })
      .json();
    latestValue = Math.ceil(Number(wattageData["values"][1][3]));
  } catch (err) {
    return { canExec: false, message: `Sheets API call failed` };
  }
  console.log(`Feeding kWh: ${latestValue}`);

  // Return execution call data
  return {
    canExec: true,
    callData: contract.interface.encodeFunctionData("mint", ['0x15e8d7bD0769Ab96B0E385C441BED3a9a21D190c', latestValue]),
  };
});