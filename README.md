# decent-queue

*NOTE*: There are two versions of our project's front end.  
- The 'main' branch, `with-queue-manager`, contains functionality for adding queues and queueing self to that queue.
- The 'secondary' branch, `develop`, contains functionality for adding queues and seeing the resulting addresses of the queues that were created.

## How to Run:
1. `npm install` for dependencies.  You may need to append `sudo` based on your configuration.
2. `truffle compile`
3. `truffle migrate`--you may need the `--reset` tag.
4. Configure MetaMask/Mist/etc. to use your desired Ethereum network.  In this example we are using Ganache/TestRPC @ `http://localhost:7545`.
5. `npm run dev`
6. Go nuts, should be served on `localhost:3000`.