# Firebase API & Client Interaction Documentation

This document describes the interaction API models used by the Flutter application to communicate with Cloud Firestore and Firebase services.

---

## 1. Authentication Endpoints

### Member OTP Authentication
Leverages Firebase Authentication SDK for Phone OTP verification.

* **Client Flow**:
  1. Trigger verification code by sending phone number.
  2. Complete registration/session by sending SMS code.
* **Payload Model**:
  ```json
  {
    "phoneNumber": "+919876543210"
  }
  ```

### Leadership ID Login
Simulated using Email/Password authentication.

* **Process Flow**:
  * Input username `taluk_tambaram_01`.
  * Flutter Client maps username to `<username>@tnpartyconnect.org`.
  * Authenticates using `signInWithEmailAndPassword`.
* **Payload Model**:
  ```json
  {
    "email": "taluk_tambaram_01@tnpartyconnect.org",
    "password": "SecurePassword123"
  }
  ```

---

## 2. Firestore Queries & Actions

### Register New Member
Creates a member record under the authenticated user ID.

* **Path**: `Collection("members").doc(uid)`
* **Method**: `Set` (Create/Overwrite)
* **Payload**:
  ```json
  {
    "fullName": "Karthik Raja",
    "dob": "1994-08-12",
    "mobileNumber": "+919876543210",
    "alternateMobileNumber": "+919876543211",
    "address": "12, Anna Salai, Chennai - 600002",
    "district": "Chennai",
    "taluk": "Egmore",
    "village": "",
    "area": "Anna Salai",
    "ward": "119",
    "profilePhotoUrl": "https://storage.googleapis.com/.../profile.jpg",
    "registeredAt": "FieldValue.serverTimestamp()",
    "status": "pending",
    "role": "member"
  }
  ```

### Fetch Public Leadership Directory
Loads the list of leadership representatives across Tamil Nadu. Sanitizes and strips PII from the presentation layer.

* **Path**: `Collection("leaders")`
* **Filter Conditions**:
  ```javascript
  where("assignedRegion.district", "==", selectedDistrict)
  .where("assignedRegion.taluk", "==", selectedTaluk)
  ```
* **Returned Fields**: `fullName`, `role`, `assignedRegion`. (*Sensitive fields are excluded*).

---

## 3. SOS Alert Triggers & Notification Escalation

### Post SOS Alert
Triggered when a member clicks the Emergency SOS button.

* **Path**: `Collection("sos_alerts").add(...)`
* **Payload**:
  ```json
  {
    "memberUid": "m1234567890",
    "memberName": "Karthik Raja",
    "mobileNumber": "+919876543210",
    "latitude": 13.0827,
    "longitude": 80.2707,
    "timestamp": "FieldValue.serverTimestamp()",
    "status": "active",
    "district": "Chennai",
    "taluk": "Egmore",
    "ward": "119"
  }
  ```

### Escalation Notification Trigger
An background Cloud Function or internal logic reacts to new documents inside `sos_alerts`.

* **Trigger**: `onCreate` of `sos_alerts/{alertId}`
* **Process**:
  1. Retrieve alert coordinates and target coordinates: `district`, `taluk`, `ward`.
  2. Query `leaders` collection to locate regional authorities matching the geography:
     * First: Ward Leader matching `ward`.
     * Second: Area/Village Leader matching `village` or `area`.
     * Third: Taluk Leader matching `taluk`.
     * Fourth: District Leader matching `district`.
  3. Send remote push notification using Firebase Cloud Messaging (FCM) to the matched leaders.
* **FCM Notification Payload**:
  ```json
  {
    "to": "/topics/leader_district_chennai",
    "notification": {
      "title": "EMERGENCY ALERT: SOS",
      "body": "SOS raised by Karthik Raja in Ward 119, Egmore."
    },
    "data": {
      "alertId": "alert_98765432",
      "latitude": "13.0827",
      "longitude": "80.2707",
      "memberName": "Karthik Raja",
      "contact": "+919876543210"
    }
  }
  ```
