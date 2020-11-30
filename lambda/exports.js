const scan = require("./scan");

exports.handler = async function (event) {
  console.log("Passed in config: ", process.env.config);
  await scan();
  // Loop through each service (Excluding from config)
  // Within each service loop through each region (Excluding from config)
  // Log results to cloudwatch
  // Notify when outside of region from config
};
