//**
// frontend/config/feature_flags.dart
//
// frontend:
// Application configuration. Menyediakan environment settings dan feature flags.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi configuration loading dan environment detection.
//**
class FeatureFlags {
  static const bool voiceEnabled = true;
  static const bool cameraEnabled = false;
}
