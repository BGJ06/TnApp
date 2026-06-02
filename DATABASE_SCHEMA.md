# Database Schema and Security Rules

This document details the database schema, fields, indexing configurations, and security access policies implemented in **Cloud Firestore** for the **TN Party Connect** platform.

---

## 1. Document Collections

### Collection: `members`
Each member profile is represented by a document whose ID matches their Firebase Auth `uid`.

| Field Name | Type | Description |
| :--- | :--- | :--- |
| `uid` | String | Unique user ID from Firebase Auth |
| `fullName` | String | Full name of the member |
| `dob` | String | Date of birth (YYYY-MM-DD) |
| `mobileNumber` | String | Principal contact number with country code |
| `alternateMobileNumber` | String | Alternate phone number |
| `address` | String | Residential address details |
| `district` | String | Registered district in Tamil Nadu |
| `taluk` | String | Registered taluk |
| `village` | String | Village (if rural) |
| `area` | String | Area (if urban) |
| `ward` | String | Ward code |
| `profilePhotoUrl` | String | Public storage URL for member image |
| `registeredAt` | Timestamp | Timestamp of sign-up completion |
| `status` | String | Approval status: `pending` or `approved` |
| `role` | String | Constant value: `member` |

### Collection: `leaders`
Contains records for party leadership profiles.

| Field Name | Type | Description |
| :--- | :--- | :--- |
| `uid` | String | User ID matching their credentials |
| `username` | String | Leadership login ID (e.g. `taluk_tambaram_01`) |
| `fullName` | String | Official name |
| `role` | String | Hierarchy role: `state_president`, `district_head`, etc. |
| `assignedRegion` | Map | Region validation fields (e.g., `{ "district": "Chennai" }`) |
| `mobileNumber` | String | Primary phone number (hidden from public view) |
| `email` | String | Login email mapping |

### Collection: `sos_alerts`
Active emergency incidents broadcasted from members.

| Field Name | Type | Description |
| :--- | :--- | :--- |
| `id` | String | Unique SOS alert identifier |
| `memberUid` | String | Issuing member's ID |
| `memberName` | String | Issuing member's full name |
| `mobileNumber` | String | Member callback number |
| `latitude` | Number | GPS Latitude |
| `longitude` | Number | GPS Longitude |
| `timestamp` | Timestamp | Timestamp of activation |
| `status` | String | Status: `active`, `acknowledged`, `resolved` |
| `district` | String | Local district for mapping escalation |
| `taluk` | String | Local taluk |
| `village` | String | Local village |
| `area` | String | Local area |
| `ward` | String | Local ward |
| `updates` | Array | Audit log tracking progress updates and actions |

### Collection: `it_wing_influencers`
Digital asset capability metrics.

| Field Name | Type | Description |
| :--- | :--- | :--- |
| `id` | String | Unique document ID |
| `fullName` | String | Influencer/worker name |
| `mobileNumber` | String | Contact number |
| `email` | String | Email address |
| `district` | String | Operating district |
| `taluk` | String | Operating taluk |
| `socialLinks` | Map | Handles (e.g., `{ "x": "@...", "instagram": "@..." }`) |
| `followerCount` | Number | Aggregate follower scale |
| `reachEstimate` | Number | Calculated weekly reach metrics |
| `category` | String | Classification: `nano`, `micro`, `macro`, `mega` |
| `skills` | Array | Core capability tags |

---

## 2. Firestore Security Rules (RBAC)

Below are the access definitions enforced by Firebase security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Check if user is a registered leader
    function isLeader() {
      return isAuthenticated() && 
        exists(/databases/$(database)/documents/leaders/$(request.auth.uid));
    }
    
    // Check specific leadership roles
    function getLeaderRole() {
      return get(/databases/$(database)/documents/leaders/$(request.auth.uid)).data.role;
    }

    // Members collection rules
    match /members/{memberId} {
      allow read: if isLeader();
      allow create: if isAuthenticated() && request.auth.uid == memberId;
      allow update, delete: if isAuthenticated() && (request.auth.uid == memberId || getLeaderRole() == 'state_president');
    }

    // Public leadership listings
    match /leaders/{leaderId} {
      allow read: if true; // Public access enabled for listing directory
      allow write: if isLeader() && getLeaderRole() == 'state_president'; // Admin only
    }

    // Emergency SOS alerts rules
    match /sos_alerts/{alertId} {
      allow create: if isAuthenticated();
      allow read, update: if isLeader();
    }

    // IT Wing Influencers rules
    match /it_wing_influencers/{influencerId} {
      allow read, write: if isLeader() && 
        (getLeaderRole() == 'state_it_head' || getLeaderRole() == 'state_president');
    }
  }
}
```
