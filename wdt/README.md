# wdt

[`debian:unstable-slim`](https://hub.docker.com/_/debian/)-based dockerization of [wdt](https://github.com/facebook/wdt), the command line tool for transferring data between 2 systems as fast as possible over multiple TCP paths

As the site says:

> Warp speed Data Transfer (WDT) is an embeddedable library (and command line tool) aiming to transfer data between 2 systems as fast as possible over multiple TCP paths. [...] Goal: Lowest possible total transfer time - to be only hardware limited (disc or network bandwidth not latency) and as efficient as possible (low CPU/memory/resources utilization)

The BSD-licensed source code for WDT is hosted on GitHub at: <https://github.com/facebook/wdt>.

The source code for the image itself is hosted on GitHub in the [backplane/conex repo](https://github.com/backplane/conex/tree/main/wdt).

The image is available at: <https://hub.docker.com/r/backplane/wdt>

## Usage

When invoked with the `--help` flag, the container emits the following help text:

```
wdt: WDT Warp-speed Data Transfer. v 1.32.1910230 p 32. Sample usage:
To transfer from srchost to desthost:
	ssh dsthost wdt -directory destdir | ssh srchost wdt -directory srcdir -
Passing - as the argument to wdt means start the sender and read the
connection URL produced by the receiver, including encryption key, from stdin.
Use --help to see all the options.

  Flags from ./src/gflags.cc:
    -flagfile (load flags from file) type: string default: ""
    -fromenv (set flags from the environment [use 'export FLAGS_flag1=value'])
      type: string default: ""
    -tryfromenv (set flags from the environment if present) type: string
      default: ""
    -undefok (comma-separated list of flag names that it is okay to specify on
      the command line even if the program does not define a flag with that
      name.  IMPORTANT: flags in this list that have arguments MUST use the
      flag=value format) type: string default: ""

  Flags from ./src/gflags_completions.cc:
    -tab_completion_columns (Number of columns to use in output for tab
      completion) type: int32 default: 80
    -tab_completion_word (If non-empty, HandleCommandLineCompletions() will
      hijack the process and attempt to do bash-style command line flag
      completion on this value.) type: string default: ""

  Flags from ./src/gflags_reporting.cc:
    -help (show help on all flags [tip: all flags can have two dashes])
      type: bool default: false currently: true
    -helpfull (show help on all flags -- same as -help) type: bool
      default: false
    -helpmatch (show help on modules whose name contains the specified substr)
      type: string default: ""
    -helpon (show help on the modules named by this flag value) type: string
      default: ""
    -helppackage (show help on all modules in the main package) type: bool
      default: false
    -helpshort (show help on only the main module for this program) type: bool
      default: false
    -helpxml (produce an xml version of help) type: bool default: false
    -version (show version and build info and exit) type: bool default: false

  Flags from ./src/logging.cc:
    -alsologtoemail (log messages go to these email addresses in addition to
      logfiles) type: string default: ""
    -alsologtostderr (log messages go to stderr in addition to logfiles)
      type: bool default: false
    -colorlogtostderr (color messages logged to stderr (if supported by
      terminal)) type: bool default: false
    -colorlogtostdout (color messages logged to stdout (if supported by
      terminal)) type: bool default: false
    -drop_log_memory (Drop in-memory buffers of log contents. Logs can grow
      very quickly and they are rarely read before they need to be evicted from
      memory. Instead, drop them from memory as soon as they are flushed to
      disk.) type: bool default: true
    -log_backtrace_at (Emit a backtrace when logging at file:linenum.)
      type: string default: ""
    -log_dir (If specified, logfiles are written into this directory instead of
      the default logging directory.) type: string default: ""
    -log_link (Put additional links to the log files in this directory)
      type: string default: ""
    -log_prefix (Prepend the log prefix to the start of each log line)
      type: bool default: true
    -log_utc_time (Use UTC time for logging.) type: bool default: false
    -log_year_in_prefix (Include the year in the log prefix) type: bool
      default: true
    -logbuflevel (Buffer log messages logged at this level or lower (-1 means
      don't buffer; 0 means buffer INFO only; ...)) type: int32 default: 0
    -logbufsecs (Buffer log messages for at most this many seconds) type: int32
      default: 30
    -logcleansecs (Clean overdue logs every this many seconds) type: int32
      default: 300
    -logemaillevel (Email log messages logged at this level or higher (0 means
      email all; 3 means email FATAL only; ...)) type: int32 default: 999
    -logfile_mode (Log file mode/permissions.) type: int32 default: 436
    -logmailer (Mailer used to send logging email) type: string default: ""
    -logtostderr (log messages go to stderr instead of logfiles) type: bool
      default: false currently: true
    -logtostdout (log messages go to stdout instead of logfiles) type: bool
      default: false
    -max_log_size (approx. maximum log file size (in MB). A value of 0 will be
      silently overridden to 1.) type: uint32 default: 1800
    -minloglevel (Messages logged at a lower level than this don't actually get
      logged anywhere) type: int32 default: 0
    -stderrthreshold (log messages at or above this level are copied to stderr
      in addition to logfiles.  This flag obsoletes --alsologtostderr.)
      type: int32 default: 2
    -stop_logging_if_full_disk (Stop attempting to log to disk if the disk is
      full.) type: bool default: false
    -timestamp_in_logfile_name (put a timestamp at the end of the log file
      name) type: bool default: true

  Flags from ./src/utilities.cc:
    -symbolize_stacktrace (Symbolize the stack trace in the tombstone)
      type: bool default: true

  Flags from ./src/vlog_is_on.cc:
    -v (Show all VLOG(m) messages for m <= this. Overridable by --vmodule.)
      type: int32 default: 0
    -vmodule (per-module verbose level. Argument is a comma-separated list of
      <module name>=<log level>. <module name> is a glob pattern, matched
      against the filename base (that is, name ignoring .cc/.h./-inl.h). <log
      level> overrides any value given by --v.) type: string default: ""



  Flags from /build/wdt/../wdt/util/WdtFlags.cpp.inc:
    -abort_check_interval_millis (Interval in ms between checking for abort
      during network i/o, a negative value or 0 disables abort check)
      type: int32 default: 200
    -accept_timeout_millis (accept timeout for wdt receiver in milliseconds)
      type: int32 default: 100
    -accept_window_millis (accept window size in milliseconds. For a session,
      after the first connection is received, other connections must be
      received within this duration) type: int32 default: 2000
    -avg_mbytes_per_sec (Target transfer rate in Mbytes/sec that should be
      maintained, specify negative for unlimited) type: double default: -1
    -backlog (Accept backlog) type: int32 default: 1
    -block_size_mbytes (Size of the blocks that files will be divided in,
      specify negative to disable the file splitting mode) type: double
      default: 16
    -buffer_size (Buffer size (per thread/socket)) type: int32 default: 262144
    -connect_timeout_millis (socket connect timeout in milliseconds)
      type: int32 default: 1000
    -delete_extra_files (If true, extra files on the receiver side is deleted
      during resumption) type: bool default: false
    -disable_preallocation (If true, files are not pre-allocated using
      posix_fallocate) type: bool default: false
    -disable_sender_verification_during_resumption (If true, sender-ip is not
      verified with the ip in transfer log. This is useful if files can be
      downloaded from different hosts) type: bool default: false
    -disk_sync_interval_mb (Disk sync interval in mb. A negative value disables
      syncing) type: double default: 0.5
    -drain_extra_ms (Extra time buffer to account for network when sender waits
      for receiver to finish processing buffered data) type: int32 default: 500
    -dscp (specify DSCP flag for the sockets used in transfers) type: int32
      default: 0
    -enable_checksum (If true, blocks are checksummed during transfer,
      redundant with gcm) type: bool default: false
    -enable_download_resumption (If true, wdt supports download resumption for
      append-only files) type: bool default: false
    -enable_heart_beat (If true, periodic heart-beat from receiver to sender is
      enabled.) type: bool default: true
    -enable_perf_stat_collection (If true, perf stats are collected and
      reported at the end of transfer) type: bool default: false
    -enable_transfer_log_compaction (If true, transfer log will be compacted
      when a transfer session finishes successfully) type: bool default: false
    -encryption_tag_interval_bytes (Encryption tag verification interval in
      bytes. A value of zero disables incremental tag verification. In that
      case, tag only gets verified at the end.) type: int32 default: 4194304
    -encryption_type (Encryption type to use. WDT currently supports aes128ctr
      (fastest but no integrity check) and aes128gcm (recommended, default). A
      value of none disables encryption (fastest but insecure)) type: string
      default: "aes128gcm"
    -exclude_regex (Regular expression representing files to exclude for
      transfer, empty/default is to not exclude any file.) type: string
      default: ""
    -follow_symlinks (If true, follow symlinks and copy them as well)
      type: bool default: false
    -fsync (If true, each file is fsync'ed after its last block is received)
      type: bool default: true
    -full_reporting (If true, transfer stats for successfully transferred files
      are included in the report) type: bool default: false
    -global_receiver_limit (Max number of receivers allowed globally. A value
      of zero disables limits) type: int32 default: 0
    -global_sender_limit (Max number of senders allowed globally. A value of
      zero disables limits) type: int32 default: 0
    -ignore_open_errors (will continue despite open errors) type: bool
      default: false
    -include_regex (Regular expression representing files to include for
      transfer empty/default is to include all files in directory. If
      exclude_regex is also specified, then files matching exclude_regex are
      excluded.) type: string default: ""
    -ipv4 (use ipv4 only, takes precedence over -ipv6) type: bool
      default: false
    -ipv6 (prefers ipv6) type: bool default: false
    -iv_change_interval_mb (Number of MBytes after which encryption iv is
      changed. A value of 0 disables iv change.) type: int32 default: 32768
    -keep_transfer_log (If true, transfer logs are not deleted at the end of
      the transfer) type: bool default: true
    -max_accept_retries (max number of retries for accept call in receiver.
      First connection from sender must come before max_accept_retries *
      accept_timeout_ms milliseconds. 0 or negative means infinite retries)
      type: int32 default: 500
    -max_mbytes_per_sec (Peak transfer rate in Mbytes/sec that should be
      maintained, specify negative for unlimited and 0 for auto configure. In
      auto configure mode peak rate will be 1.2 times average rate)
      type: double default: 0
    -max_retries (how many attempts to connect/listen) type: int32 default: 20
    -max_transfer_retries (Maximum number of times sender thread reconnects
      without making any progress) type: int32 default: 3
    -namespace_receiver_limit (Max number of receivers allowed per namespace. A
      value of zero disables limits) type: int32 default: 1
    -namespace_sender_limit (Max number of senders allowed per namespace. A
      value of zero disables limits) type: int32 default: 0
    -num_ports (Number of sockets) type: int32 default: 8
    -odirect_reads (Wdt can read files in O_DIRECT mode, set this flag to true
      to make sender read all files in O_DIRECT) type: bool default: false
    -open_files_during_discovery (If >0 up to that many files are opened when
      they are discovered.0 for none. -1 for trying to open all the files
      during discovery) type: int32 default: 0
    -overwrite (Allow the receiver to overwrite existing files) type: bool
      default: false
    -progress_report_interval_millis (Interval(ms) between progress reports. If
      the value is 0, no progress reporting is done) type: int32 default: 20
    -prune_dir_regex (Regular expression representing directories to exclude
      for transfer, default/empty is to recurse in all directories)
      type: string default: ""
    -read_timeout_millis (socket read timeout in milliseconds) type: int32
      default: 5000
    -receive_buffer_size (Receive buffer size for receiver sockets. If <= 0,
      buffer size is not set) type: int32 default: 0
    -resume_using_dir_tree (If true, destination directory tree is trusted
      during resumption. So, only the remaining portion of the files are
      transferred. This is only supported if preallocation and block mode are
      disabled) type: bool default: false
    -send_buffer_size (Send buffer size for sender sockets. If <= 0, buffer
      size is not set) type: int32 default: 0
    -skip_fadvise (If true, fadvise is skipped after block write) type: bool
      default: false
    -skip_writes (Skip writes on the receiver side) type: bool default: false
    -sleep_millis (how many ms to wait between attempts) type: int32
      default: 50
    -start_port (Starting port number for wdt, if set, implies static_ports)
      type: int32 default: 22356
    -static_ports (Use static ports (start_port) or any free port) type: bool
      default: false
    -throttler_bucket_limit (Limit of burst in Mbytes to control how much data
      you can send at unlimited speed. Unless you specify a peak rate of -1,
      wdt will either use your burst limit (if not 0) or max burst possible at
      a time will be 2 times the data allowed in 1/4th seconds at peak rate)
      type: double default: 0
    -throttler_log_time_millis (Peak throttler prints out logs for
      instantaneous rate of transfer. Specify the time interval (ms) for the
      measure of instance) type: int64 default: 0
    -throughput_update_interval_millis (Intervals in millis after which
      progress reporter updates current throughput) type: int32 default: 500
    -transfer_log_write_interval_ms (Interval in milliseconds after which
      transfer log is written to disk. written to disk) type: int32
      default: 100
    -two_phases (do directory discovery first/separately) type: bool
      default: false
    -write_timeout_millis (socket write timeout in milliseconds) type: int32
      default: 5000



  Flags from /build/wdt/ErrorCodes.cpp:
    -wdt_double_precision (Precision while printing double) type: int32
      default: 2
    -wdt_logging_enabled (To enable/disable WDT logging.) type: bool
      default: true



  Flags from /build/wdt/util/WdtFlags.cpp:
    -option_type (WDT option type. Options are initialized to different values
      depending on the type. Individual options can still be changed using
      specific flags. Use -print_options to see values) type: string
      default: "flash"



  Flags from /build/wdt/wdtCmdLine.cpp:
    -abort_after_seconds (Abort transfer after given seconds. 0 means don't
      abort.) type: int32 default: 0
    -app_name (Identifier used for reporting (scuba, at fb)) type: string
      default: "wdt"
    -connection_url (Provide the connection string to connect to receiver
      (incl. transfer_id and other parameters). Deprecated: use - arg instead
      for safe encryption key transmission) type: string default: ""
    -dest_id (Unique destination identifier (will default to hostname))
      type: string default: ""
    -destination (empty is server (destination) mode, non empty is destination
      host) type: string default: ""
    -directory (Source/Destination directory) type: string default: "."
    -exit_on_bad_flags (If true, wdt exits on bad/unknown flag. Otherwise, an
      unknown flags are ignored) type: bool default: true
    -fork (If true, forks the receiver, if false, no forking/stay in fg)
      type: bool default: false
    -hostname (override hostname in transfe request) type: string default: ""
    -manifest (If specified, then we will read a list of files and optional
      sizes from this file, use - for stdin) type: string default: ""
    -namespace (WDT namespace (e.g shard)) type: string default: ""
    -parse_transfer_log (If true, transfer log is parsed and fixed) type: bool
      default: false
    -print_options (If true, wdt prints the option values and exits. Option
      values printed take into account option type and other command line flags
      specified.) type: bool default: false
    -protocol_version (facebook::wdt::Protocol version to use, this is used to
      simulate protocol negotiation) type: int32 default: 0
    -recovery_id (Recovery-id to use for download resumption) type: string
      default: ""
    -run_as_daemon (If true, run the receiver as never ending process)
      type: bool default: false
    -test_only_encryption_secret (Test only encryption secret, to test url
      encoding/decoding) type: string default: ""
    -transfer_id (Transfer id. Receiver will generate one to be used (via URL)
      on the sender if not set explicitly) type: string default: ""
    -treat_fewer_port_as_error (If the receiver is unable to bind to all the
      ports, treat that as an error.) type: bool default: false
```
