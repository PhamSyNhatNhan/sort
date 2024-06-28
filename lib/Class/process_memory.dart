import 'dart:ffi';

final class PROCESS_MEMORY_COUNTERS extends Struct {
  @Int32()
  external int cb;

  @Uint32()
  external int PageFaultCount;

  @IntPtr()
  external int PeakWorkingSetSize;

  @IntPtr()
  external int WorkingSetSize;

  @IntPtr()
  external int QuotaPeakPagedPoolUsage;

  @IntPtr()
  external int QuotaPagedPoolUsage;

  @IntPtr()
  external int QuotaPeakNonPagedPoolUsage;

  @IntPtr()
  external int QuotaNonPagedPoolUsage;

  @IntPtr()
  external int PagefileUsage;

  @IntPtr()
  external int PeakPagefileUsage;
}