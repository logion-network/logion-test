# Logion Test

The purpose of this project is to easily deploy locally a complete logion infrastructure in order to enable
the testing of the platform as a whole.

## Usage

Run the following command to execute logion locally:

    ./scripts/start.sh

You should now be able to connect to the app ([http://localhost:8080](http://localhost:8080)).

Initially, you may see some screens assisting you in the on-boarding process which essentially consists in:

1. Install the [Polkadot extension](https://polkadot.js.org/extension/).
2. Add accounts into it.

After that, you'll be invited to log in. This is done by signing with the extension. Once logged in, you can use the
account switcher (upper right corner of the window) in order to:

- log in with another account,
- switch to another account
- log out.

Note that, by default, logion's Docker images with `latest` tag are being used. In order to select other tags, you
can save `.env.sample` file as `.env` and modify `.env`'s content to suite your needs.

## Use cases

This section describes the "script" to run when testing a given use case.

### Account protection

0. Deploy logion locally.
1. Add [test accounts](https://github.com/logion-network/logion-wallet#test-users) to your [Polkadot extension](https://polkadot.js.org/extension/).
2. Log in as a regular user (i.e. any account which is not part of the set of test legal officers).
3. In the dialog popping up, click on "Activate the logion protection" button.
4. Choose the 2 first legal officers in the list (Alice and Bob), fill-in the form and click on "Next" button.
5. Log in legal officer Alice.
6. In the menu, click on "Protection Management".
7. In the "Pending" tab, locate your request and click on "Review and process" button.
8. Accept the request by clicking on "Yes" button and choose "Create the required Identity LOC". Click on "Submit", sign then click on "OK".
9. Click on "Close and accept request", then click on "Confirm" and sign. You should now see the request marked as "Accepted" in the history.
10. Log in legal officer Bob and execute steps 6 to 9.
11. In the menu, click on "Wallet" then "Send" and transfer some LGNTs (0.0001 should do) to the user of step 2.
12. Switch back to the regular user and, in the menu, click on "My Logion Protection".
13. Click on "Activate" button and sign the transaction (this actually creates the recovery configuration on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
14. With the [Polkadot JS app](https://polkadot.js.org/apps), see that the account is now recoverable.

### Account recovery

0. If not already done, run steps of "Account protection" use case.
1. Log in as another regular user and Alice.
2. Switch to account Alice, click on "Wallet", click on "Send" and transfer some LGNTs to the user of step 1.
3. Switch to the user of step 1. In the dialog popping up, click on "Start a recovery process" button.
4. Fill-in "Addresss to Recover" field with the address of the regular user used in "Account protection" use case.
5. Click on "Initiate recovery" button (this initiates the recovery on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
6. Choose the same legal officers as in "Account protection" use case (Alice and Bob), fill-in the form and click on "Next" button.
7. Switch to legal officer Alice and click on "Recovery Requests" in the menu.
8. Locate the recovery request in the table and click on "Review and process".
9. Accept the request by clicking on "Proceed" button and select "Create the required Identity LOC". Click on "Submit", sign then click on "OK".
10. Click on "Close and accept request", then click on "Confirm" and sign. Sign an additional transaction (this vouches for the recovery attempt on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)). You should now see the request marked as "Accepted" in the history.
11. Switch to legal officer Bob, click on "Recovery Requests" in the menu and run steps 8, 9 and 10.
12. Switch to the regular user of step 1 and click on "Recovery" in the menu.
13. Click on "Activate" button and sign the transaction (this creates the recovery configuration on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
14. Click on "Claim" (this claims the access to recovered account on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
15. Click on "Transfer" to transfer your assets from recovered account.

### Register legal officers with directory

0. Deploy logion locally.
1. With the [Polkadot JS app](https://polkadot.js.org/apps), register Charlie as a legal officer by executing the extrinsic
   `loAuthorityList.addLegalOfficer(legalOfficerId)` with `legalOfficerId` equal to `5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y`.
2. Log in as Charlie, set the name to "Charlie" and Node Base URL to `http://locahost:8082`, click on "Save" then "Refresh".
   You should now see an error message telling that Charlie's node is unreachable.
3. In the `docker-compose.yml` file, uncomment the 2 sections starting with comment `Uncomment next line if you want to bring Charlie's node up`.
4. Start the new node by executing `docker-compose up -d`.
5. Go to `http://localhost:8082` and log in as Charlie.

### Distributed backup test

0. If not already done, add data to the private database (e.g. by running the steps of use case "Account protection").
1. Wait for more or less one minute to make sure that all data were backed up (see [here](https://github.com/logion-network/logion-pg-backup-manager#readme) for 
   a detailed explanation of why this is so).
2. Run `./scripts/restore_demo.sh`: this will clear the private database of node 1 and restore the data from IPFS.
