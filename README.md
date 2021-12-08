# Logion Test

The purpose of this project is to easily deploy locally a complete logion infrastructure in order to enable
the testing of the platform as a whole.

## Usage

Run the following command to execute logion locally:

    docker-compose up

You should now be able to connect to the app ([http://localhost:8080](http://localhost:8080)).

Initially, you may see some screens assisting you in the on-boarding process which essentially consists in:

1. Install the [Polkadot extension](https://polkadot.js.org/extension/).
2. Add accounts into it.

After that, you'll be invited to log in. This is done by signing with the extension. Once logged in, you can use the
account switcher (upper right corner of the window) in order to:

- log in with another account,
- switch to another account
- log out.

## Use cases

This section describes the "script" to run when testing a given use case.

### Account protection

Below steps are executed by a new user which wants to activate the protection on its account. Essentially, the process consists in contacting
two legal officers to ask them to become "friends" (in the [recovery pallet](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs) sense).
The legal officers, after doing their due diligence, may accept the request. Once both legal officers accepted, the new user may activate the protection on-chain 
(before that, the process is fully off-chain).

Note that currently, a legal officer has to send some tokens to new users. Otherwise, they would not be able to submit extrinsics. A better solution will be designed in the future.

0. Deploy logion locally.
1. Add [test accounts](https://github.com/logion-network/logion-wallet#test-users) to your [Polkadot extension](https://polkadot.js.org/extension/).
2. Log in as a regular user (i.e. any account which is not part of the set of test legal officers).
3. In the dialog popping up, click on "Activate the logion protection" button.
4. Choose the 2 first legal officers in the list (Patrick and Guillaume), fill-in the form and click on "Next" button.
5. Log in legal officer Patrick (i.e. with Alice account) and switch.
6. In the menu, click on "Protection Management".
7. In the "Pending" tab, locate your request and click on "Review and process" button.
8. Accept the request by clicking on "Yes" button.
9. Log in legal officer Guillaume (i.e. with Bob account), switch and execute steps 8 and 9.
10. In the menu, click on "Wallet" then on the "Send" button (under the gauge) and send some tokens (e.g. 0.1 LGNT) to the regular user of step 2.
11. Switch back to the regular user and, in the menu, click on "My Logion Protection".
12. Click on "Activate" button and sign the transaction (this actually creates the recovery configuration on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
13. (Optional) With the [Polkadot JS app](https://polkadot.js.org/apps), you can check that the account is now recoverable.

### Account recovery

Below steps are executed by an existing user which wants to gain access to one of its protected accounts after he/she lost the keys. Essentially, the process
consists in creating a new account and asking to the legal officers which protected the lost account (the "friends") to "vouch" for the recovery request on-chain.
Once both legal officers vouched for the request (after doing their due diligence), the user can claim the access to the lost account using the new one. The new 
account then acts as a proxy and can be used to transfer all the assets in the lost account to the new account.

0. If not already done, run steps of "Account protection" use case. At this stage, you are logged in as a regular user, legal officer Patrick and legal officer Guillaume.
1. Switch to legal officer Patrick (i.e. with Alice account).
2. In the menu, click on "Wallet" then on the "Send" button (under the gauge) and send some tokens (e.g. 0.1 LGNT) to the new regular user that will start a recovery.
3. Log in as the new regular user of step 2 and switch.
4. In the dialog popping up, click on "Start a recovery process" button.
5. Fill-in "Addresss to Recover" field with the address of the regular user used in "Account protection" use case.
6. Click on "Initiate recovery" button (this initiates the recovery on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
7. Choose the same legal officers as in "Account protection" use case (Patrick and Guillaume), fill-in the form and click on "Next" button.
8. Switch to legal officer Patrick and click on "Recovery Requests" in the menu.
9. Locate the recovery request in the table and click on "Review and process".
10. Accept the request by clicking on "Proceed" button.
11. In the dialog popping-up, click on "Confirm and sign" and sign the transaction (this vouches for the recovery attempt on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
12. Switch to legal officer Guillaume, click on "Recovery Requests" in the menu and run steps 8, 9 and 10.
13. Switch to the regular user of step 1 and click on "Recovery" in the menu.
14. Click on "Activate" button and sign the transaction (this creates the recovery configuration on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
15. Click on "Claim" (this claims the access to recovered account on-chain,
    see [recovery pallet documentation](https://github.com/paritytech/substrate/blob/master/frame/recovery/src/lib.rs)).
16. Transfer the tokens of recovered account to the recovering account by clicking the "Transfer" button in the table.
