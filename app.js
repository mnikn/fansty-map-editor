let currentSelectNode = null;

// handle move node event
d3.select(document)
  .on(
    "mouseup",
    e => {
      currentSelectNode = null;
      d3.select("#node-selected-container").style("visibility", "hidden");
    },
    false
  )
  .on(
    "mousemove",
    e => {
      if (currentSelectNode) {
        moveNode(currentSelectNode, { x: e.x, y: e.y });
      }
    },
    false
  )
  .on("mousedown", e => {
    if (e.target.parentElement.className.baseVal === "map-node") {
      currentSelectNode = e.target.parentElement;
      const { origin } = JSON.parse(currentSelectNode.dataset.nodeConfig);
      moveNode(currentSelectNode, origin);
    }
  });

function createNode({ origin, radius, lineWidth, lineColor, pointNum }) {
  const points = getNodePoints({ origin, radius, pointNum });

  d3.select("#canvas")
    .selectAll("polyline")
    .data([points])
    .enter()
    .append("g")
    .attr(
      "data-node-config",
      JSON.stringify({
        origin,
        radius,
        lineWidth,
        lineColor,
        pointNum
      })
    )
    .attr("class", "map-node")
    .append("polyline")
    .attr("points", d => {
      return d
        .map(p => {
          return `${p.x} ${p.y}`;
        })
        .join(" ");
    })
    .attr("fill", "transparent")
    .attr("stroke", lineColor)
    .attr("stroke-width", lineWidth);
}

function getNodePoints({ origin, pointNum, radius }) {
  const points = [];
  for (let i = 0; i <= pointNum; i++) {
    const degree = i * (360 / pointNum);
    const x = Math.cos(((Math.PI * 2) / 360) * degree) * radius + origin.x;
    const y = Math.sin(((Math.PI * 2) / 360) * degree) * radius + origin.y;
    points.push({
      x: x,
      y: y
    });
  }
  return points;
}

function moveNode(node, targetOrigin) {
  const containerSize = Number(
    document.querySelector("#node-selected-container").dataset.containerSize
  );
  const nodeConfig = JSON.parse(currentSelectNode.dataset.nodeConfig);
  const { radius, pointNum } = nodeConfig;
  nodeConfig.origin = targetOrigin;
  currentSelectNode.dataset.nodeConfig = JSON.stringify(nodeConfig);

  const points = getNodePoints({
    origin: targetOrigin,
    radius,
    pointNum
  })
    .map(p => `${p.x} ${p.y}`)
    .join(" ");
  d3.select(currentSelectNode)
    .select("polyline")
    .attr("points", points);

  d3.select("#node-selected-container")
    .style("visibility", "visible")
    .select("rect")
    .attr("x", targetOrigin.x - radius - containerSize)
    .attr("y", targetOrigin.y - radius - containerSize)
    .attr("height", (radius + containerSize) * 2)
    .attr("width", (radius + containerSize) * 2);
  d3.select("#node-selected-container")
    .select("circle")
    .attr("cx", targetOrigin.x)
    .attr("cy", targetOrigin.y);
}

function main() {
  const origin = { x: 100, y: 100 };
  const radius = 50;
  const lineWidth = 2;
  const lineColor = "black";
  const pointNum = 18;
  createNode({
    origin,
    radius,
    lineWidth,
    lineColor,
    pointNum
  });
}

main();
