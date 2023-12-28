import { Contract, Wallet, WebSocketProvider } from 'ethers';
import fetch from 'node-fetch';
import ContractABI from '../artifacts/contracts/TokenOracle.sol/TokenOracle.json';
import 'dotenv/config';

const PRIVATE_KEY = process.env.PRIVATE_KEY || "";

const provider = new WebSocketProvider('wss://polygon-mumbai.g.alchemy.com/v2/qjdPtbgJvR7wYeoaBXp5-wD-MsyxpXKt');

const signer = new Wallet(PRIVATE_KEY, provider);

const contract = new Contract('0xCE7E51E0EDF52C42fAAd042aCA559d47b7A4f309', ContractABI.abi, signer);

contract.on('RequestPrice', async () => {
  console.log('RequestPrice');
  const result = await fetch('https://api.wazirx.com/api/v2/tickers/btcusdt');
  const resultFormatted = await result.json();
  const price = await resultFormatted.ticker.last;
  console.log('price :>> ', price);
  const updatePrice = await contract.setPrice(Number(price));
  await updatePrice.wait();
  const currentPrice = await contract.price();
  console.log('currentPrice :>> ', currentPrice);
});

contract.on('SetPrice', (price: number) => {
  console.log('SetPrice', price);
});