import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
const REGION = 'europe-west1'; // Belgium, closest to Firestore location (europe-west2 - Frankfurt)

export const handleNewPatient =
    functions.region(REGION).firestore.document('Patients/{patientID}')
        .onCreate((snapshot, _) => {
            const patient = snapshot.data();

            console.log("Received new patient");
            console.log(patient);

            if (patient !== undefined) {
                return sendPatientId(patient.id)
                    .catch((err: Error) => {
                        console.log("Error occured");
                        console.log(err);
                    })
            } else {
                throw new Error("no patient data inserted into db");
            }
        })


function sendPatientId(patientId: string): Promise<any> {
    const payload = {
        data: { patientId: patientId }
    }
    return admin.messaging().sendToTopic("all", payload)
}
