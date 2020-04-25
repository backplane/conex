# graphviz

[`alpine:edge`](https://hub.docker.com/_/alpine/)-based dockerization of [graphviz](https://graphviz.gitlab.io/), graph visualization software with a thin wrapper

As the site says:

> [Graphviz](https://www.graphviz.org/) is open source graph visualization software. It has several main graph layout programs. [...] It also has web and interactive graphical interfaces, and auxiliary tools, libraries, and language bindings. [...] The Graphviz layout programs take descriptions of graphs in a simple text language, and make diagrams in several useful formats such as images and SVG for web pages, Postscript for inclusion in PDF or other documents; or display in an interactive graph browser. (Graphviz also supports GXL, an XML dialect.)
>
>Graphviz has many useful features for concrete diagrams, such as options for colors, fonts, tabular node layouts, line styles, hyperlinks, and custom shapes.

## Usage

See [Graphviz Command-line Invocation](https://graphviz.org/_pages/doc/info/command.html) for general information about calling graphviz from the command line.

* [`acyclic`](https://graphviz.gitlab.io/_pages/pdf/acyclic.1.pdf) - make directed graph acyclic'
* [`bcomps`](https://graphviz.gitlab.io/_pages/pdf/bcomps.1.pdf) - biconnected components filter for graphs'
* [`ccomps`](https://graphviz.gitlab.io/_pages/pdf/ccomps.1.pdf) - connected components filter for graphs'
* [`circo`](https://graphviz.gitlab.io/_pages/pdf/dot.1.pdf) - filter for circular layout of graphs'
* [`cluster`](https://graphviz.gitlab.io/_pages/pdf/cluster.1.pdf) - find clusters in a graph and augment the graph with this information'
* [`dijkstra`](https://graphviz.gitlab.io/_pages/pdf/dijkstra.1.pdf) - single-source distance filter'
* [`dot_builtins`](https://graphviz.gitlab.io/_pages/pdf/dot.1.pdf) - undocumented'
* [`dot`](https://graphviz.gitlab.io/_pages/pdf/dot.1.pdf) - filter for drawing directed graphs'
* [`dot2gxl`](https://graphviz.gitlab.io/_pages/pdf/dot2gxl.1.pdf) - GXL-GV converters'
* [`dotty`](https://graphviz.gitlab.io/_pages/pdf/dotty.1.pdf) - customizable graph editor (an X11 app - not tested in this container)'
* [`edgepaint`](https://graphviz.gitlab.io/_pages/pdf/edgepaint.1.pdf) - edge coloring to disambiguate crossing edges'
* [`fdp`](https://graphviz.gitlab.io/_pages/pdf/dot.1.pdf) - filter for drawing undirected graphs'
* [`gc`](https://graphviz.gitlab.io/_pages/pdf/gc.1.pdf) - count graph components'
* [`gml2gv`](https://graphviz.gitlab.io/_pages/pdf/gml2gv.1.pdf) - GML-DOT converter'
* [`graphml2gv`](https://graphviz.gitlab.io/_pages/pdf/graphml2gv.1.pdf) - GRAPHML-DOT converter'
* [`gv2gml`](https://graphviz.gitlab.io/_pages/pdf/gv2gml.1.pdf) - GML-DOT converter'
* [`gv2gxl`](https://graphviz.gitlab.io/_pages/pdf/gv2gxl.1.pdf) - GXL-GV converters'
* [`gvcolor`](https://graphviz.gitlab.io/_pages/pdf/gvcolor.1.pdf) - flow colors through a ranked digraph (previously known as colorize)'
* [`gvgen`](https://graphviz.gitlab.io/_pages/pdf/gvgen.1.pdf) - generate graphs'
* [`gvmap.sh`](https://graphviz.gitlab.io/_pages/pdf/gvmap.sh.1.pdf) - find clusters and create a geographical map highlighting clusters'
* [`gvmap`](https://graphviz.gitlab.io/_pages/pdf/gvmap.1.pdf) - find clusters and create a geographical map highlighting clusters'
* [`gvpack`](https://graphviz.gitlab.io/_pages/pdf/gvpack.1.pdf) - merge and pack disjoint graphs'
* [`gvpr`](https://graphviz.gitlab.io/_pages/pdf/gvpr.1.pdf) - graph pattern scanning and processing language'
* [`gxl2dot`](https://graphviz.gitlab.io/_pages/pdf/gxl2dot.1.pdf) - GXL-GV converters'
* [`gxl2gv`](https://graphviz.gitlab.io/_pages/pdf/gxl2gv.1.pdf) - GXL-GV converters'
* [`lefty`](https://graphviz.gitlab.io/_pages/pdf/lefty.1.pdf) - a programmable two-view graphics editor for technical pictures'
* [`lneato`](https://graphviz.gitlab.io/_pages/pdf/lneato.1.pdf) - customizable graph editor (an X11 app - not tested in this container)'
* [`mm2gv`](https://graphviz.gitlab.io/_pages/pdf/mm2gv.1.pdf) - Matrix Market-DOT converters'
* [`neato`](https://graphviz.gitlab.io/_pages/pdf/dot.1.pdf) - filter for drawing undirected graphs'
* [`nop`](https://graphviz.gitlab.io/_pages/pdf/nop.1.pdf) - pretty-print graph files'
* [`osage`](https://graphviz.gitlab.io/_pages/pdf/osage.1.pdf) - filter for array-based layouts'
* [`patchwork`](https://graphviz.gitlab.io/_pages/pdf/patchwork.1.pdf) - filter for squarified tree maps'
* [`prune`](https://graphviz.gitlab.io/_pages/pdf/prune.1.pdf) - undocumented'
* [`sccmap`](https://graphviz.gitlab.io/_pages/pdf/sccmap.1.pdf) - extract strongly connected components of directed graphs'
* [`sfdp`](https://graphviz.gitlab.io/_pages/pdf/dot.1.pdf) - filter for drawing large undirected graphs'
* [`tred`](https://graphviz.gitlab.io/_pages/pdf/tred.1.pdf) - transitive reduction filter for directed graphs'
* [`twopi`](https://graphviz.gitlab.io/_pages/pdf/dot.1.pdf) - filter for radial layouts of graphs'
* [`unflatten`](https://graphviz.gitlab.io/_pages/pdf/unflatten.1.pdf) - adjust directed graphs to improve layout aspect ratio'
* [`vimdot`](https://graphviz.gitlab.io/_pages/pdf/vimdot.1.pdf) - combined text editor and dot viewer'

The image is intended to be used interactively and the following shell function can assist in running this image this way:

```sh

graphviz() {
  docker run \
    --rm \
    --interactive \
    --tty \
    --volume "$(pwd):/work" \
    "galvanist/conex:graphviz" \
    "$@"
}

```

When invoking the image this way, this help text applies:

```
Usage: graphviz [-h|--help] command [command_options [...]]

"command" is one of the following, which runs the corresponding binary from the graphviz package:

* acyclic - make directed graph acyclic
* bcomps - biconnected components filter for graphs
* ccomps - connected components filter for graphs
* circo - filter for circular layout of graphs
* cluster - find clusters in a graph and augment the graph with this information
* dijkstra - single-source distance filter
* dot - filter for drawing directed graphs
* dot_builtins - undocumented
* dot2gxl - GXL-GV converters
* dotty - customizable graph editor (an X11 app - not tested in this container)
* edgepaint - edge coloring to disambiguate crossing edges
* fdp - filter for drawing undirected graphs
* gc - count graph components
* gml2gv - GML-DOT converter
* graphml2gv - GRAPHML-DOT converter
* gv2gml - GML-DOT converter
* gv2gxl - GXL-GV converters
* gvcolor - flow colors through a ranked digraph (previously known as colorize)
* gvgen - generate graphs
* gvmap - find clusters and create a geographical map highlighting clusters
* gvmap.sh - find clusters and create a geographical map highlighting clusters
* gvpack - merge and pack disjoint graphs
* gvpr - graph pattern scanning and processing language
* gxl2dot - GXL-GV converters
* gxl2gv - GXL-GV converters
* lefty - a programmable two-view graphics editor for technical pictures
* lneato - customizable graph editor (an X11 app - not tested in this container)
* mm2gv - Matrix Market-DOT converters
* neato - filter for drawing undirected graphs
* nop - pretty-print graph files
* osage - filter for array-based layouts
* patchwork - filter for squarified tree maps
* prune - undocumented
* sccmap - extract strongly connected components of directed graphs
* sfdp - filter for drawing large undirected graphs
* tred - transitive reduction filter for directed graphs
* twopi - filter for radial layouts of graphs
* unflatten - adjust directed graphs to improve layout aspect ratio
* vimdot - combined text editor and dot viewer

Each command has additional options (including "-?" and sometimes "-h")
```
