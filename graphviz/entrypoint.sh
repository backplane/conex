#!/bin/sh
# wrapper around poppler-util commands


usage() {
  self="graphviz"
  [ -n "$*" ] && printf "ERROR: %s\n\n" "$*" >&2

  printf '%s\n' \
    "Usage: ${self} [-h|--help] command [command_options [...]]" \
    '' \
    '"command" is one of the following, which runs the corresponding binary from the graphviz package:' \
    '' \
    '* acyclic - make directed graph acyclic' \
    '* bcomps - biconnected components filter for graphs' \
    '* ccomps - connected components filter for graphs' \
    '* circo - filter for circular layout of graphs' \
    '* cluster - find clusters in a graph and augment the graph with this information' \
    '* dijkstra - single-source distance filter' \
    '* dot - filter for drawing directed graphs' \
    '* dot_builtins - undocumented' \
    '* dot2gxl - GXL-GV converters' \
    '* dotty - customizable graph editor (an X11 app - not tested in this container)' \
    '* edgepaint - edge coloring to disambiguate crossing edges' \
    '* fdp - filter for drawing undirected graphs' \
    '* gc - count graph components' \
    '* gml2gv - GML-DOT converter' \
    '* graphml2gv - GRAPHML-DOT converter' \
    '* gv2gml - GML-DOT converter' \
    '* gv2gxl - GXL-GV converters' \
    '* gvcolor - flow colors through a ranked digraph (previously known as colorize)' \
    '* gvgen - generate graphs' \
    '* gvmap - find clusters and create a geographical map highlighting clusters' \
    '* gvmapsh - find clusters and create a geographical map highlighting clusters' \
    '* gvpack - merge and pack disjoint graphs' \
    '* gvpr - graph pattern scanning and processing language' \
    '* gxl2dot - GXL-GV converters' \
    '* gxl2gv - GXL-GV converters' \
    '* lefty - a programmable two-view graphics editor for technical pictures' \
    '* lneato - customizable graph editor (an X11 app - not tested in this container)' \
    '* mm2gv - Matrix Market-DOT converters' \
    '* neato - filter for drawing undirected graphs' \
    '* nop - pretty-print graph files' \
    '* osage - filter for array-based layouts' \
    '* patchwork - filter for squarified tree maps' \
    '* prune - undocumented' \
    '* sccmap - extract strongly connected components of directed graphs' \
    '* sfdp - filter for drawing large undirected graphs' \
    '* tred - transitive reduction filter for directed graphs' \
    '* twopi - filter for radial layouts of graphs' \
    '* unflatten - adjust directed graphs to improve layout aspect ratio' \
    '* vimdot - combined text editor and dot viewer' \
    '' \
    'Each command has additional options (including "-h")' \
    >&2

  exit 1
}


main() {
  cmd="$1"; shift

  [ -n "$cmd" ] || usage

  case "$cmd" in
    -h|-help|--help)
      usage
      ;;

    acyclic|bcomps|ccomps|circo|cluster|dijkstra|dot|dot2gxl|dot_builtins|dotty|edgepaint|fdp|gc|gml2gv|graphml2gv|gv2gml|gv2gxl|gvcolor|gvgen|gvmap|gvmap.sh|gvpack|gvpr|gxl2dot|gxl2gv|lefty|lneato|mm2gv|neato|nop|osage|patchwork|prune|sccmap|sfdp|tred|twopi|unflatten|vimdot)
      exec "/usr/bin/${cmd}" "$@"
      ;;

    *)
      usage "Unknown command ${cmd}"
      ;;
  esac

  # should be unreachable
  exit 2
}


[ -n "$IMPORT" ] || main "$@"
