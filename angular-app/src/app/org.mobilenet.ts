import {Asset} from './org.hyperledger.composer.system';
import {Participant} from './org.hyperledger.composer.system';
import {Transaction} from './org.hyperledger.composer.system';
import {Event} from './org.hyperledger.composer.system';
// export namespace org.mobilenet{
   export class Mobile extends Asset {
      macAddress: string;
      name: string;
      description: string;
      owner: User;
   }
   export class User extends Participant {
      userId: string;
      firstName: string;
      lastName: string;
   }
   export class Transfer extends Transaction {
      mobile: Mobile;
      newOwner: User;
   }
   export class TransferNotification extends Event {
      mobile: Mobile;
   }
// }
