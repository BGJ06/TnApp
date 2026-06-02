# TN Party Connect

A production-ready Android mobile application built with Flutter & Firebase designed for Tamil Nadu political party organizational structure, member management, leadership communications, IT Wing/Influencer tracking, and emergency SOS services.

## Overview

TN Party Connect provides a robust management tool for managing statewide party activities. It has two main pillars:
1. **Public/Member Access**: Open registration, public leadership directory search, and regional SOS request dispatching.
2. **Internal Leadership Access**: Role-Based Access Control (RBAC), approval pipelines for new members, emergency escalation tracking, and digital skill matrix management for IT wing and social media influencers.

## Geographic Scope & Hierarchy

The application structure is built specifically for **Tamil Nadu, India** and supports the following geographical hierarchy:
```
Tamil Nadu (State)
└── District (e.g., Chennai, Madurai, Coimbatore, Trichy)
    └── Taluk
        └── Village (Rural) / Area (Urban)
            └── Ward
                └── Member
```

## Technology Stack

- **Frontend**: Flutter (Dart) using clean architecture, Provider/Riverpod for state management, and Material 3 responsive design.
- **Backend Services**: Firebase Suite:
  - **Firebase Authentication**: Mobile Phone OTP for members, and User ID + Password for leadership accounts.
  - **Cloud Firestore**: Real-time scalable document database for member records, directories, SOS tracking, and skill registries.
  - **Firebase Cloud Messaging (FCM)**: Remote notifications for SOS alerts and broadcast alerts.
  - **Cloud Storage**: Secure media/photo uploads for member profile photos and documents.
- **Geospatial Tracking**: `geolocator` and `google_maps_flutter` for emergency coordinates tracking.

## Repository Layout

- `/tn_party_connect`: Complete Flutter source code.
- `/firebase`: Firestore rules, indexes, and Cloud Functions configurations.
- `/docs`: Detailed manuals including API designs, schemas, deployment workflows, and installations.
