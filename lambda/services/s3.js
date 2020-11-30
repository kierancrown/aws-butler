const AWS = require("aws-sdk");
const s3 = new AWS.S3({ apiVersion: "2006-03-01" });

const alertTest = require("../alert");

module.exports = async (s3Alert) => {
  console.log(s3Alert);
  try {
    const buckets = await s3.listBuckets().promise();
    await alertTest(
      `S3 Bucket count: ${
        Array.isArray(buckets.Buckets) ? buckets.Buckets.length : 0
      }`
    );
    return Array.isArray(buckets.Buckets) ? buckets.Buckets.length : 0;
  } catch (error) {
    console.error(error);
  }
};
