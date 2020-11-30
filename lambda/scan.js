const s3BucketCount = require("./services/s3");
const lambdaListFunctions = require("./services/lambda");

module.exports = async () => {
  const alerts = JSON.parse(process.env.alerts);

  let s3Alert;
  if (Array.isArray(alerts))
    s3Alert = alerts.filter((a) => {
      return a.alertType === "s3_bucket_threshold";
    })[0];

  console.log("Scan started...");
  console.time("scantime");
  console.log(`S3 Bucket Count (All Regions): ${await s3BucketCount(s3Alert)}`);
  await lambdaListFunctions();
  console.log(`Scan completed`, console.timeEnd("scantime"));
};
