"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const admin = __importStar(require("firebase-admin"));
const seed_data_1 = require("./seed-data");
let db;
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
    }
    catch (e) {
        console.warn('Could not load service-account.json, falling back to default credentials.');
        // console.warn('Error:', e);
        admin.initializeApp({
            projectId: 'quangninhtravel-ca9a0'
        });
        db = admin.firestore();
        console.log('Initialized with Default Credentials');
    }
}
else {
    db = admin.firestore();
}
console.log('Attempting to connect to Firestore...');
(0, seed_data_1.seedDatabase)(db)
    .then(results => {
    console.log('Seed results:', JSON.stringify(results, null, 2));
    process.exit(0);
})
    .catch(error => {
    console.error('Seed failed completely. Error details:');
    console.error(error);
    process.exit(1);
});
//# sourceMappingURL=run-seed.js.map