
// To check if a library is compiled with CocoaPods you
// can use the `COCOAPODS` macro definition which is
// defined in the xcconfigs so it is available in
// headers also when they are imported in the client
// project.


// Debug build configuration
#ifdef DEBUG

  // Lookback
  #define COCOAPODS_POD_AVAILABLE_Lookback
  #define COCOAPODS_VERSION_MAJOR_Lookback 1
  #define COCOAPODS_VERSION_MINOR_Lookback 0
  #define COCOAPODS_VERSION_PATCH_Lookback 2

#endif
// Release build configuration
#ifdef RELEASE

  // LookbackSafe
  #define COCOAPODS_POD_AVAILABLE_LookbackSafe
  #define COCOAPODS_VERSION_MAJOR_LookbackSafe 1
  #define COCOAPODS_VERSION_MINOR_LookbackSafe 0
  #define COCOAPODS_VERSION_PATCH_LookbackSafe 2

#endif
