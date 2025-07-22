/// Breakpoints for responsive design.
/// These values are used to determine the size of the device and apply appropriate styles.
/// The values are based on common device sizes and can be adjusted as needed.
/// The breakpoints are defined in dp.
/// Here's, how other smallest width values correspond to typical screen sizes:
/// - 320dp: Small phone screen (240x320 ldpi, 320x480 mdpi, 480x800 hdpi, etc.)
/// - 480dp: Large phone screen ~5" (480x800 mdpi)
/// - 600dp: 7" tablet (600x1024 mdpi)
/// - 720dp: 10" tablet (720x1280 mdpi, 800x1280 mdpi, etc.)
library;

class ResponsiveBreakpoint {
  static const double xs = 0.0; // Extra small devices (phones)
  static const double sm = 600.0; // Small devices (phones)
  static const double md = 960.0; // Medium devices (tablets)
  static const double lg = 1280.0; // Large devices ( desktops)
  static const double xl = 1920.0; // Extra large devices (large desktops)
  static const double max = double.infinity; // Maximum size for any device
  static const double min = 0.0; // Minimum size for any device
}
