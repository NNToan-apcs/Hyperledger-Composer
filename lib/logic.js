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
//  * @param { org.mobilenet.Transfer} transfer - the Transfer to be processed
//  * @transaction
//  */

// async function transferMobile(transfer) {

//     // set the new owner of the commodity
//     transfer.mobile.owner = transfer.newOwner;
//     let assetRegistry = await getAssetRegistry('org.mobilenet.Mobile');

//     // emit a notification that a Transfer has occurred
//     let transferNotification = getFactory().newEvent('org.mobilenet', 'TransferNotification');
//     transferNotification.mobile = transfer.mobile;
//     emit(transferNotification);

//     // persist the state of the commodity
//     await assetRegistry.update(transfer.mobile);
// }


/**
 * Track the Transfer of a commodity from one User to another
 * @param { org.mobilenet.AddStudentToCourse} CourseAccess - the Transfer to be processed
 * @transaction
 */

async function GivePermission(CourseAccess) {

    // set the new owner of the commodity
    // IF NOT LECTURER => FAIL (TODO)
    CourseAccess.course.learners.push(CourseAccess.student);
    let assetRegistry = await getAssetRegistry('org.mobilenet.Course');

    // emit a notification that a Transfer has occurred
    let SuccessNotification = getFactory().newEvent('org.mobilenet', 'AddStudentToCourseSuccessNotification');
    SuccessNotification.course = CourseAccess.course;
    SuccessNotification.student = CourseAccess.student;
    emit(SuccessNotification);

    // persist the state of the course
    await assetRegistry.update(CourseAccess.course);

}
