# Logion Test

The purpose of this project is to easily deploy locally a complete logion node in order to enable the testing of the
platform as a whole.

## Usage

Run the following command to execute logion locally:

    docker-compose up

You should now be able to connect to the app ([http://localhost](http://localhost)).

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
4. Choose the 2 first legal officers in the list (Patrick and Guillaume), fill-in the form and click on "Next" button.
5. Log in legal officer Patrick (i.e. with Alice account).
6. In the menu, click on "Protection Management".
7. In the "Pending" tab, locate your request and click on "Review and process" button.
8. Accept the request by clicking on "Yes" button.
0. Log in legal officer Guillaume (i.e. with Bob account) and execute steps 8 and 9.
10. With the [Polkadot JS app](https://polkadot.js.org/apps), connect to the local node and transfer some logs to the
    user of step 3.
11. Switch back to the regular user and, in the menu, click on "My Logion Protection".
12. Click on "Activate" button and sign the transaction (this actually creates the recovery configuration on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
13. With the [Polkadot JS app](https://polkadot.js.org/apps), see that the account is now recoverable.

### Account recovery

0. If not already done, run steps of "Account protection" use case.
1. Log in as another regular user.
2. In the dialog popping up, click on "Start a recovery process" button.
3. With the [Polkadot JS app](https://polkadot.js.org/apps), connect to the local node and transfer some logs to the
    user of step 1.
4. Fill-in "Addresss to Recover" field with the address of the regular user used in "Account protection" use case.
5. Click on "Initiate recovery" button (this initiates the recovery on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
6. Choose the same legal officers as in "Account protection" use case (Patrick and Guillaume), fill-in the form and click on "Next" button.
7. Switch to legal officer Patrick and click on "Recovery Requests" in the menu.
8. Locate the recovery request in the table and click on "Review and process".
9. Accept the request by clicking on "Proceed" button.
10. In the dialog popping-up, click on "Confirm and sign" and sign the transaction (this vouches for the recovery attempt on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
11. Switch to legal officer Guillaume, click on "Recovery Requests" in the menu and run steps 8, 9 and 10.
12. Switch to the regular user of step 1 and click on "Recovery" in the menu.
13. Click on "Activate" button and sign the transaction (this creates the recovery configuration on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
13. Click on "Claim" (this claims the access to recovered account on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
