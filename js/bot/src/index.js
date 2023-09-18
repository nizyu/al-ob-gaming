const AWS = require('aws-sdk');
const intaraction = require('discord-interactions');
const axios = require('axios');

const lambda = new AWS.Lambda();

{
  InteractionResponseType,
  InteractionType,
  verifyKey,
} from "discord-interactions";


// Handler
exports.handler = async function (event, context) {
  if (!verifyRequest(event)) {
    return {
      statusCode: 400,
    };
  }

  const interaction = JSON.parse(event.body);
	
	
  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(handleInteraction(interaction)),
  };
};



const verifyRequest = (event) => {
  const { headers, body } = event;
  const lowerHeader = lowercaseKeys(headers);

  const signature = lowerHeader["x-signature-ed25519"];
  const timestamp = lowerHeader["x-signature-timestamp"];
  const publicKey = process.env["DISCORD_PUBLIC_KEY"];
  if (!body || !signature || !timestamp || !publicKey) {
    return false;
  }
  return verifyKey(body, signature, timestamp, publicKey);
};

const lowercaseKeys = (obj) => {
  return Object.fromEntries(
    Object.entries(obj).map(([key, value]) => [key.toLowerCase(), value])
  );
};


// interaction の処理
const handleInteraction = (interaction: Record<string, unknown>) => {
  if (interaction.type === InteractionType.APPLICATION_COMMAND) {
    const { data } = interaction as { data: Record<string, unknown> };
    if (data.name === "hello") {
      return {
        type: InteractionResponseType.CHANNEL_MESSAGE_WITH_SOURCE,
        data: {
          content: "hello, world",
        },
      };
    }
  }

  return { type: InteractionResponseType.PONG };
};
