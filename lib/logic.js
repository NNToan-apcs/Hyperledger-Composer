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

/* global getAssetRegistry getFactory emit */

/**
 * Sample transaction processor function.
 * @param {org.trading.net.TransferMoney} tx The sample transaction instance.
 * @transaction
 */
async function transferMoney(tx) {  // eslint-disable-line no-unused-vars
	// Transfer money to another user
    let currentParticipant = getCurrentParticipant();
 	let recipient = tx.recipient;
    let amount = tx.amount;
  	// Throw an error as the current participant is not a User.
    if (currentParticipant.getFullyQualifiedType() !== 'org.trading.net.User') {
        throw new Error('Current participant is not a User');
    }
  
  	if (tx.amount <= 0){
      throw new Error('Invalid transfer amount');
    }
  	// Throw an error as the user do not have enough money
  	
	if (currentParticipant.balance < tx.amount){
      throw new Error('You do not have enough money to transfer');
    }
  
 	let participantRegistry = await getParticipantRegistry('org.trading.net.User');   
  
  	let exists = await participantRegistry.exists(recipient.getIdentifier());
  	// Throw an error as the recipient is not existed
  	if(!exists){
      throw new Error('Recipient is not existed');
    }
  	
    // Update new balance for both sender and recipient
  	currentParticipant.balance -= amount;
    recipient.balance += amount;

    // emit a notification that a Transfer has occurred
    let SuccessNotification = getFactory().newEvent('org.trading.net', 'TransferSuccessfully');
    SuccessNotification.from = currentParticipant;
    SuccessNotification.to = recipient;	
    SuccessNotification.amount = amount;
    emit(SuccessNotification);

    // persist the state of participants
    await participantRegistry.update(currentParticipant);
	await participantRegistry.update(recipient);
}
