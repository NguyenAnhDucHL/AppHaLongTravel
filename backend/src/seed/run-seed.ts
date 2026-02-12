import * as admin from 'firebase-admin';
import { seedDatabase } from './seed-data';

let db: admin.firestore.Firestore;

// Initialize Firebase Admin
if (!admin.apps.length) {
    try {
        // If running locally with firebase login, this uses application default credentials
        // But for robust local seeding, we use the service account key
        const serviceAccount = require('../../service-account.json');

        console.log('Project ID from config:', 'quangninhtravel-ca9a0');
        // console.log('Service Account Project ID:', serviceAccount.project_id);

        admin.initializeApp({
            credential: admin.credential.cert(serviceAccount)
        });

        db = admin.firestore();
        // Force HTTP to avoid gRPC issues on some environments
        db.settings({ ignoreUndefinedProperties: true });
        console.log('Initialized with Service Account');

    } catch (e) {
        console.warn('Could not load service-account.json, falling back to default credentials.');
        // console.warn('Error:', e);
        admin.initializeApp({
            projectId: 'quangninhtravel-ca9a0'
        });
        db = admin.firestore();
        console.log('Initialized with Default Credentials');
    }
} else {
    db = admin.firestore();
}

console.log('Attempting to connect to Firestore...');
seedDatabase(db)
    .then(results => {
        console.log('Seed results:', JSON.stringify(results, null, 2));
        process.exit(0);
    })
    .catch(error => {
        console.error('Seed failed completely. Error details:');
        console.error(error);
        process.exit(1);
    });
