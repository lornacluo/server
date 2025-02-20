#!/usr/bin/perl -i
#
# This script converts all numbers that look like addresses or memory sizes,
# in a debug files generated by --debug (like mysqld --debug-dbug), to #.
# The script also deletes all thread id's from the start of the line.

# This allows you to easily compare the files (for example with diff)
# to find out what changes between different executions.
# This is extremely useful for comparing two mysqld versions to see
# why things now work differently.

# The script converts the files in place.
#
# Typical usage:
#
# convert-debug-for-diff /tmp/mysqld.trace /tmp/mysqld-old.trace
# diff /tmp/mysqld.trace /tmp/mysqld-old.trace

while (<>)
{
  s/^T@[0-9]+ *://g;
  s/0x[0-9a-f]+(\s|\n|\)|=|,|;)/#$1/g;
  s/size: [0-9-]+/size: #/g;
  s/memory_used: [0-9]+/memory_used: #/g;
  s/Total alloc: [0-9]+/Total alloc: #/g;
  s/(proc_info: )(.*:)[\d]+ /$1 /;
  s/(select_cond.*) at line.*/$1/;
  s/\(id: \d+ -> \d+\)/id: #->#/g;
  s/(exit: found key at )\d+/$1#/g;
  s/enter_stage: ([^\/]*)(\/.*\/)(.*)(:\d+)/enter_stage: ($1)/g;
  s/crc: [0-9]+/crc: #/g;
  s/ref_count: [0-9]+/ref_count: #/g;
  s/block: # \(\d+\)/block: # (#)/g;
  s/delete_mutex: #  mutex: #  \(id: \d+ \<\- \d+\)/delete_mutex: #  mutex: #  (id: # <- #)/g;
  s/ShortTrID: [0-9]+/ShortTrID: #/g;
  s/timestamp:[0-9]+/timestamp:#/g;
  s/#sql_.*_(\d+)/#sql_xxx_$1/g;
  s/fd: [0-9]+/fd: #/g;
  s/query_id: (\d+)/query_id: #/g;
  s|: .*/mysql-test/var/tmp/mysqld\.\d|d: var/tmp/mysqld|g;
  print $_;
}
