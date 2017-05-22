<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>MADlib via REST Example</title>

        <link href="css/bootstrap.min.css" rel="stylesheet" />
        <link href="css/jumbotron-narrow.css" rel="stylesheet" />
        <script src="js/sigma/sigma.min.js"></script>
        <script src="js/sigma/plugins/sigma.layout.forceAtlas2.min.js"></script>
        <script src="js/d3/d3.js"></script>

        <!-- Add some CSS so we can see the graph! -->
        <style>
          #network-graph {
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            position: absolute;
            z-index: -1;
          }
        </style>
    </head>

    <body bgcolor="#000">
        <div class="jumbotron" style="z-index: 1; opacity: 0.85;">
            <h3 style="opacity: 1;">PCF Netflow PageRank Visualization</h3>
            <h5 style="opacity: 1;"><i>brought to you by Greenplum, MADlib, and Spring</i></h5>
        </div>

        <div id="network-graph" ></div>
        <script type="text/javascript">

            var s = new sigma({
              container: 'network-graph'
            });

            var colors = "#0d0887,#100788,#130789,#16078a,#19068c,#1b068d,#1d068e,#20068f,#220690,#240691,#260591,#280592,#2a0593,#2c0594,#2e0595,#2f0596,#310597,#330597,#350498,#370499,#38049a,#3a049a,#3c049b,#3e049c,#3f049c,#41049d,#43039e,#44039e,#46039f,#48039f,#4903a0,#4b03a1,#4c02a1,#4e02a2,#5002a2,#5102a3,#5302a3,#5502a4,#5601a4,#5801a4,#5901a5,#5b01a5,#5c01a6,#5e01a6,#6001a6,#6100a7,#6300a7,#6400a7,#6600a7,#6700a8,#6900a8,#6a00a8,#6c00a8,#6e00a8,#6f00a8,#7100a8,#7201a8,#7401a8,#7501a8,#7701a8,#7801a8,#7a02a8,#7b02a8,#7d03a8,#7e03a8,#8004a8,#8104a7,#8305a7,#8405a7,#8606a6,#8707a6,#8808a6,#8a09a5,#8b0aa5,#8d0ba5,#8e0ca4,#8f0da4,#910ea3,#920fa3,#9410a2,#9511a1,#9613a1,#9814a0,#99159f,#9a169f,#9c179e,#9d189d,#9e199d,#a01a9c,#a11b9b,#a21d9a,#a31e9a,#a51f99,#a62098,#a72197,#a82296,#aa2395,#ab2494,#ac2694,#ad2793,#ae2892,#b02991,#b12a90,#b22b8f,#b32c8e,#b42e8d,#b52f8c,#b6308b,#b7318a,#b83289,#ba3388,#bb3488,#bc3587,#bd3786,#be3885,#bf3984,#c03a83,#c13b82,#c23c81,#c33d80,#c43e7f,#c5407e,#c6417d,#c7427c,#c8437b,#c9447a,#ca457a,#cb4679,#cc4778,#cc4977,#cd4a76,#ce4b75,#cf4c74,#d04d73,#d14e72,#d24f71,#d35171,#d45270,#d5536f,#d5546e,#d6556d,#d7566c,#d8576b,#d9586a,#da5a6a,#da5b69,#db5c68,#dc5d67,#dd5e66,#de5f65,#de6164,#df6263,#e06363,#e16462,#e26561,#e26660,#e3685f,#e4695e,#e56a5d,#e56b5d,#e66c5c,#e76e5b,#e76f5a,#e87059,#e97158,#e97257,#ea7457,#eb7556,#eb7655,#ec7754,#ed7953,#ed7a52,#ee7b51,#ef7c51,#ef7e50,#f07f4f,#f0804e,#f1814d,#f1834c,#f2844b,#f3854b,#f3874a,#f48849,#f48948,#f58b47,#f58c46,#f68d45,#f68f44,#f79044,#f79143,#f79342,#f89441,#f89540,#f9973f,#f9983e,#f99a3e,#fa9b3d,#fa9c3c,#fa9e3b,#fb9f3a,#fba139,#fba238,#fca338,#fca537,#fca636,#fca835,#fca934,#fdab33,#fdac33,#fdae32,#fdaf31,#fdb130,#fdb22f,#fdb42f,#fdb52e,#feb72d,#feb82c,#feba2c,#febb2b,#febd2a,#febe2a,#fec029,#fdc229,#fdc328,#fdc527,#fdc627,#fdc827,#fdca26,#fdcb26,#fccd25,#fcce25,#fcd025,#fcd225,#fbd324,#fbd524,#fbd724,#fad824,#fada24,#f9dc24,#f9dd25,#f8df25,#f8e125,#f7e225,#f7e425,#f6e626,#f6e826,#f5e926,#f5eb27,#f4ed27,#f3ee27,#f3f027,#f2f227,#f1f426,#f1f525,#f0f724,#f0f921";
            var cmap = d3.scale.quantize();
            cmap.range(colors.split(","));
            cmap.domain([0, 0.5]);
            
            var ecolors = "#a50026,#d73027,#f46d43,#fdae61,#fee090,#e0f3f8,#abd9e9,#74add1,#4575b4,#313695";
            var ecmap = d3.scale.quantize();
            ecmap.range(ecolors.split(",").reverse());
            ecmap.domain([1, 500]);

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
                        size: arr[i].rank,
                        color: cmap(arr[i].rank*10)
                      });
                    } catch (e) {
                      console.log(e);
                      console.log(colors[Math.floor((i / arr.length) * colors.length)]);
                    }
                    //console.log(arr[i].rank);
                });

                // Finally, let's ask our sigma instance to refresh:
                s.refresh();
            });

            
            //var e = [];
            d3.json('/pagerank/edges/5000', function(edata) {
                //e = edata;
                edata.forEach(function(obj, i, arr) {
                    try {
                      s.graph.addEdge({
                        // Main attributes:
                        id: i,
                        source: arr[i].source,
                        target: arr[i].target,
                        size: arr[i].weight,
                        color: ecmap(arr[i].weight)
                      });
                    } catch (e) {
                        //console.log(e);
                    }
                });

                // Finally, let's ask our sigma instance to refresh:
                s.refresh();

                //s.startForceAtlas2();
            });
            

        </script>

    </body>
    
</html>
