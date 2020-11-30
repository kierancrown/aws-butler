const AWS = require("aws-sdk");

const discoverFunctions = async (params = {}, region = "eu-west-1") => {
  const lambda = new AWS.Lambda({
    apiVersion: "2015-03-31",
    region,
  });
  return lambda.listFunctions(params).promise();
};

let functionsCache = [];
const getFunctions = async (_nextMarker = "") => {
  // Loop through discover functions until marker is empty
  let res;
  if (_nextMarker !== "")
    res = await discoverFunctions({
      Marker: _nextMarker,
    });
  else res = await discoverFunctions();
  if (res.Functions) {
    res.Functions.forEach((func) => {
      functionsCache.push(func);
    });
  }
  if (res.NextMarker && res.NextMarker !== "") {
    return getFunctions(res.NextMarker);
    // Rerun to get more results
  }
  // End of results add current batch of functions and previous functions and return them
  return functionsCache;
};

module.exports = async () => {
  const functions = await getFunctions();
  return functions.length;
};
