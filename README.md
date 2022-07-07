# SOLYD Ethereum Contracts Dev Environment

Version 3.0

> “If we wish to count lines of code, 
> we should not regard them as ‘lines produced’ 
> but as ‘lines spent.'”
> — Edsger Dijkstra

## Operating Commands


### Local Testing

npx hardhat compile

npx hardhat test

npx hardhat node

npx hardhat --network localhost run scripts/deploy.js
npx hardhat --network SKALE_TEST run scripts/deploy.js
npx hardhat --network SKALE_V2 run scripts/deploy_test.js