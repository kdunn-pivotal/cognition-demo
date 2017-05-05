<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>MADlib via REST Example</title>
<!--
        <link href="css/bootstrap.min.css" rel="stylesheet" />
        <link href="css/jumbotron-narrow.css" rel="stylesheet" />
-->
        <script src="js/sigma/sigma.min.js"></script>
        <script src="js/sigma/plugins/sigma.layout.forceAtlas2.min.js"></script>
        <script src="js/d3/d3.js"></script>

        <!--script type="text/javascript" src="js/vendor.js"></script-->

<!-- Add some CSS so we can see the graph! -->
<style>
  #network-graph {
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    position: absolute;
  }
</style>
    </head>

    <body >
        <!--div class="jumbotron"-->
        <div id="network-graph" ></div>
        <script type="text/javascript">

            //var graphJSON = { "nodes": n , "edges": e } ;

            var s = new sigma({
              /*graph: graphJSON,*/
              container: 'network-graph'
            });

            //var n = [];
            d3.json('/pagerank/top/100', function(ndata) {
                //n = ndata;

                // Then, let's add some data to display:
                ndata.forEach(function(obj, i, arr) {
                    //console.log(arr[i].label);
                    try {
                      s.graph.addNode({
                        // Main attributes:
                        id: arr[i].id,
                        label: arr[i].label,
                        // Display attributes:
                        x: Math.cos(Math.PI * 2 * i / arr.length),
                        y: Math.sin(Math.PI * 2 * i / arr.length),
                        size: arr[i].rank * 20,
                        color: '#f00'
                      });
                    } catch (e) {
                      console.log(e)  
                    }
                    //console.log(arr[i].rank);
                });

                // Finally, let's ask our sigma instance to refresh:
                s.refresh();
            });

            
            //var e = [];
            d3.json('/pagerank/edges/10000', function(edata) {
                //e = edata;
                edata.forEach(function(obj, i, arr) {
                    try {
                      s.graph.addEdge({
                        // Main attributes:
                        id: i,
                        source: arr[i].source,
                        target: arr[i].target
                      });
                    } catch (e) {
                        console.log(e);
                    }
                });

                // Finally, let's ask our sigma instance to refresh:
                s.refresh();

                //s.startForceAtlas2();
            });
            

            /*
            */

            //Initialize nodes as a circle
            /*
            s.graph.nodes().forEach(function(node, i, a) {
              node.x = Math.cos(Math.PI * 2 * i / a.length);
              node.y = Math.sin(Math.PI * 2 * i / a.length);
            });
            */


            //s.startForceAtlas2(); 

            /*
            // Then, let's add some data to display:
            s.graph.addNode({
              // Main attributes:
              id: 'n0',
              label: 'Hello',
              // Display attributes:
              x: 0,
              y: 0,
              size: 1,
              color: '#f00'
            }).addNode({
              // Main attributes:
              id: 'n1',
              label: 'World !',
              // Display attributes:
              x: 1,
              y: 1,
              size: 1,
              color: '#00f'
            }).addEdge({
              id: 'e0',
              // Reference extremities:
              source: 'n0',
              target: 'n1'
            });
            */

        </script>

        <!--/div-->
    </body>
    
</html>
