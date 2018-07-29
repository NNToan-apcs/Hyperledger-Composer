/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';
/**
 * Write your transction processor functions here
 */


// /**
//  * Track the Transfer of a commodity from one User to another
//  * @param { org.trading.net.Transfer} transfer - the Transfer to be processed
//  * @transaction
//  */

// async function transferMobile(transfer) {

//     // set the new owner of the commodity
//     transfer.mobile.owner = transfer.newOwner;
//     let assetRegistry = await getAssetRegistry('org.trading.net.Mobile');

//     // emit a notification that a Transfer has occurred
//     let transferNotification = getFactory().newEvent('org.trading.net', 'TransferNotification');
//     transferNotification.mobile = transfer.mobile;
//     emit(transferNotification);

//     // persist the state of the commodity
//     await assetRegistry.update(transfer.mobile);
// }


/**
 * Track the Transfer of a commodity from one trader to another
 * @param { org.trading.net.TransferCommodity} Transfer - the Transfer to be processed
 * @transaction
 */

async function transferCommodity(Transfer) {

    // set the new owner of the commodity
    // IF NOT LECTURER => FAIL
    let currentParticipant = getCurrentParticipant();
    console.log("AAAAAAAAAAAAAAAAAAAAAA");
    if (currentParticipant.getFullyQualifiedType() !== 'org.trading.net.Trader') {
        // Throw an error as the current participant is not a driver.
        throw new Error('Current participant is not a Trader');
    }
    console.log("BBBBBBBBBBBBBBBBBBBBBBBBb");
    if (currentParticipant.getFullyQualifiedIdentifier() !== Transfer.commodity.owner.getFullyQualifiedIdentifier()) {
        throw new Error('Transaction can only be submitted by the owner of the commodity');
    }
    console.log("CCCCCCCCCCCCCCCCCCCCCCCCCCC");
    let newOwner = Transfer.newOwner;
    if (!getAssetxRegistry('org.trading.net.Trader').exists(newOwner.getIdentifer()))
    {
        throw new Error('newOwner not exists');
    }
    console.log("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
    // Update new owner for community
    Transfer.commodity.owner = Transfer.newOwner;
    let assetRegistry = await getAssetRegistry('org.trading.net.Commodity');

    // emit a notification that a Transfer has occurred
    let SuccessNotification = getFactory().newEvent('org.trading.net', 'TransferCommoditySuccessNotification');
    SuccessNotification.commodity = Transfer.commodity;
    SuccessNotification.newOwner = Transfer.newOwner;
    emit(SuccessNotification);

    // persist the state of the course
    await assetRegistry.update(Transfer.commodity);

}

