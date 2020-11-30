const AWS = require("aws-sdk");
const s3 = new AWS.S3({ apiVersion: "2006-03-01" });

module.exports = async (s3Alert) => {
  console.log(s3Alert);
  try {
    const buckets = await s3.listBuckets().promise();
    return Array.isArray(buckets.Buckets) ? buckets.Buckets.length : 0;
  } catch (error) {
    console.error(error);
  }
};

const getBucketCount = async () => {};
