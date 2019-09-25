#ifndef COPYBUNDLEID_H
#define COPYBUNDLEID_H

// Global Constants
static NSString* const actionTypeId = @"com.coord-e.copybundleid";
static const CFStringRef preferenceId   = CFSTR("com.coord-e.copybundleid");
static const CFStringRef notificationId = CFSTR("com.coord-e.copybundleid/ReloadPrefs");

typedef struct {
  bool isEnabled;
  bool isSoundEnabled;
  bool isAlertEnabled;
} Config;

// Global Instances
static Config config;
static NSData* iconData;

#endif
