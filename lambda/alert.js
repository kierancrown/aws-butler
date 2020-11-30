// This file will send alerts via SES

var AWS = require("aws-sdk");
var sns = new AWS.SNS({ region: "eu-west-1" });
const arn = process.env.snsArn;

module.exports = async (msg) => {
  var params = {
    Message: msg,
    Subject: "AWS Butler Alert",
    TopicArn: arn,
  };

  sns.publish(params).promise();
};
