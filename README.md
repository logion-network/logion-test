# Logion Test

The purpose of this project is to easily deploy a complete logion infrastructure locally in order to enable
the functional testing of the platform as a whole.

## Requirements

- Docker
- Docker Compose
- Bash (see scripts for more details)

## Initial setup

Below steps must be executed only if you did not yet create the `logion-test` network.

- Create `logion-test network`: `docker network create logion-test`
- Get network's gateway IP address: `docker network inspect logion-test | jq '.[0].IPAM.Config[0].Gateway'`
- Set `RPC_WS` variable in `.env` file (see `.env.sample` for an example) with the above IP address

## Usage

First, instantiate the Logion chain locally
(see [here](https://github.com/logion-network/logion-collator/?tab=readme-ov-file#test-locally) for instructions).

In another terminal, run the following command to execute logion locally:

```
./scripts/up.sh
```

You should now be able to connect to the app ([http://localhost:8080](http://localhost:8080)).

Initially, you may see some screens assisting you in the on-boarding process which essentially consists in:

1. Install the [Polkadot extension](https://polkadot.js.org/extension/).
2. Add accounts into it.

After that, you'll be invited to log in. This is done by signing with the extension. Once logged in, you will be able to
switch accounts (upper right corner of the window).

The first time you start the logion infrastructure (or after a data reset), you'll have to register at least one legal officer.
To do so, log in as Alice (see [here](https://github.com/logion-network/logion-wallet#test-users) to see how you can add Alice,
Bob and Charlie to your extension) and fill-in:

- directory data (at least name and e-mail) and
- the node URL (`http://localhost:8080` for Alice, `http://localhost:8081` for Bob and `http://localhost:8082` for Charlie).

Do not forget to save and publish.

You may also use `./script/init_data.sh` which will automatically fill-in the data for all legal officers both in the directory
and on chain. Before running the script for the first time, do not forget to install Node.JS and run `yarn`.

Note that, by default, logion's Docker images with `latest` tag are being used. In order to select other tags, update `.env` file.

Once you are done testing, you may want to:

- Clean-up: run `./scripts/down.sh` and stop Zombienet
- Restart from scratch: restart Zombienet, then run `./scripts/reset.sh`

## Use cases

This section describes the "script" to run when testing a given use case.

### Account protection

Below steps are executed by a new user which wants to activate the protection on its account. Essentially, the process consists in contacting two legal officers to ask them to become "friends" (in the recovery pallet sense). The legal officers, after doing their due diligence, may accept the request. Once both legal officers accepted, the new user may activate the protection on-chain.

Note that currently, a legal officer has to send some tokens to new users. Otherwise, they would not be able to submit extrinsics. A better solution will be designed in the future.

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
11. In the menu, click on "Wallet" then "Send" and transfer some LGNTs (1 LGNT should do) to the user of step 2.
12. Switch back to the regular user and, in the menu, click on "My Logion Protection".
13. Click on "Activate" button and sign the transaction (this actually creates the recovery configuration on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
14. With the [Polkadot JS app](https://polkadot.js.org/apps), see that the account is now recoverable.

### Account recovery

Below steps are executed by an existing user which wants to gain access to one of its protected accounts after he/she lost the keys. Essentially, the process consists in creating a new account and asking to the legal officers which protected the lost account (the "friends") to "vouch" for the recovery request on-chain. Once both legal officers vouched for the request (after doing their due diligence), the user can claim the access to the lost account using the new one. The new account then acts as a proxy and can be used to transfer all the assets in the lost account to the new account.

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

### Distributed backup test

Below steps simulate a disaster recovery. Step 2 essentially consists in erasing node 1's private data then restoring them (see script for more details).

0. If not already done, add data to the private database (e.g. by running the steps of use case "Account protection").
1. Wait for more or less one minute to make sure that all data were backed up (see [here](https://github.com/logion-network/logion-pg-backup-manager#readme) for 
   a detailed explanation of why this is so).
2. Run `./scripts/restore_demo.sh`: this will clear the private database of node 1 and restore the data from IPFS.

### Multisig

Below steps describe how a user, after activating its protection (step 0), is able to protect assets by transferring them into its Vault (steps 2 and 3) and
how, later, it's able to transfer the assets back with one of its legal officers actually countersigning the operation (steps 6 to 9).

0. If not already done, run steps of "Account protection" use case.
1. Switch to the regular user
2. In the menu, click on "Wallet" then "Send to Vault" button
3. Set an amount (lower than available balance, mind the units), click "Transfer" and sign.
4. In the menu, click on "Vault", you should now see the transferred LGNTs in your Vault (i.e. the multisig account).
5. On the logion token row, click on "More".
6. Click on "Request a vault-out transfer" then set the regular user's address, set an amount to transfer back and choose Alice.
7. Click on transfer.
8. Switch to legal officer Alice and, in the menu, click on "Vault-out requests".
9. Click on the "V" in order to accept the request then click on "Proceed".
10. Switch to the regular user and go back to the Vault, see that the transaction has been executed (Vault account balance is lower).
