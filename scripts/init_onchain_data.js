import { LogionNodeApiClass } from "@logion/node-api";
import { Keyring } from '@polkadot/api';

let api;
let keyring;
let alice;
let bob;
let charlie;

LogionNodeApiClass.connect("ws://localhost:9944")
.then(api0 => {
    api = api0.polkadot;
    keyring = new Keyring({ type: 'sr25519' });
    alice = keyring.addFromUri("0xe5be9a5092b81bca64be81d212e7f2f9eba183bb7a90954f7b76361f6edb5c0a");
    bob = keyring.addFromUri("0x398f0c28f98885e046333d4a41c19cee4c37368a9832c6502f6cfd182e2aef89");
    charlie = keyring.addFromUri("0xbc1ede780f784bb6991a585e4f6e61522c14e1cae6ad0895fb57b9a205a8f938");

    return signAndSend(alice, api.tx.loAuthorityList
        .updateLegalOfficer(alice.address, {
            Host: {
                nodeId: "0x0024080112201ce5f00ef6e89374afb625f1ae4c1546d31234e87e3c3f51a62b91dd6bfa57df",
                baseUrl: "http://localhost:8080",
                region: "Europe",
            }
        }));
})
.then(result => {
    console.log(`Alice update: ${result.status}`);
    return signAndSend(bob, api.tx.loAuthorityList
        .updateLegalOfficer(bob.address, {
            Host: {
                nodeId: "0x002408011220dacde7714d8551f674b8bb4b54239383c76a2b286fa436e93b2b7eb226bf4de7",
                baseUrl: "http://localhost:8081",
                region: "Europe",
            }
        }));
})
.then(result => {
    console.log(`Bob update: ${result.status}`);
    return signAndSend(alice, api.tx.sudo.sudo(
        api.tx.loAuthorityList.updateLegalOfficer(charlie.address, {
            Guest: alice.address
        })
    ));
})
.then(result => {
    console.log(`Charlie update: ${result.status}`);
    return api.disconnect();
})
.then(() => {
    console.log("Done");
});

async function signAndSend(keypair, extrinsic) {
    let unsub;
    const promise = new Promise((resolve, error) => {
        extrinsic.signAndSend(keypair, (result) => {
            if(result.isError) {
                unsub();
                error();
            } else if (result.status.isInBlock) {
                unsub();
                if(result.dispatchError) {
                    error();
                } else {
                    resolve(result);
                }
            }
        })
        .then(_unsub => unsub = _unsub)
        .catch(e => error("" + e));
    });
    try {
        return await promise;
    } catch(e) {
        throw new Error("" + e);
    }
}
